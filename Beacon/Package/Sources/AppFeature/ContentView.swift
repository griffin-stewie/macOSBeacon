//
//  ContentView.swift
//  macOSBeacon
//
//  Created by griffin-stewie on 2021/12/10.
//  
//

import SwiftUI
import Beacon

public struct ContentView: View {

    @EnvironmentObject var peripheralViewModel: PeripheralViewModel
    @AppStorage("uuidString") var uuidString: String = "D57092AC-DFAA-446C-8EF3-C81AA22815B5"
    @AppStorage("major") var major: String = "5"
    @AppStorage("minor") var minor: String = "5000"
    @AppStorage("measuredPower") var measuredPower: String = "-10"

    public init() {}

    public var body: some View {
        VStack(spacing: 30) {
            GroupBox(label: Text("Beacon Settings")) {
                VStack(spacing: 30) {
                    VStack(alignment: .leading) {
                        Text("UUID: ")
                            .bold()
                        TextField("UUID", text: $uuidString, prompt: Text("Input UUID"))
                            .textFieldStyle(.roundedBorder)
                    }
                    .disabled(peripheralViewModel.isAdvertising)

                    HStack {
                        VStack(alignment: .leading) {
                            Text("Major: ")
                                .bold()
                            TextField("Major", text: $major, prompt: Text("Major"))
                                .textFieldStyle(.roundedBorder)
                        }

                        VStack(alignment: .leading) {
                            Text("Minor: ")
                                .bold()
                            TextField("Minor", text: $minor, prompt: Text("Minor"))
                                .textFieldStyle(.roundedBorder)
                        }

                        VStack(alignment: .leading) {
                            Text("Pwr: ")
                                .bold()
                            TextField("Measured Power", text: $measuredPower, prompt: Text("Measured Pwr"))
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    .disabled(peripheralViewModel.isAdvertising)
                }
                .padding()
            }

            Button(peripheralViewModel.isAdvertising ? "Stop" : "Start") {
                if peripheralViewModel.isAdvertising {
                    peripheralViewModel.stopAdvertising()
                } else {
                    guard let data = BeaconAdvertisementData(uuid: uuidString, major: major, minor: minor, measuredPower: measuredPower) else {
                        return
                    }

                    peripheralViewModel.startAdvertise(with: data)
                }
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .disabled(!peripheralViewModel.isReady)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let peripheral: Peripheral = Peripheral()

    static var previews: some View {
        ContentView()
            .environmentObject(peripheral.peripheralViewModel)
    }
}
