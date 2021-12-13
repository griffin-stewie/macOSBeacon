//
//  macOSBeaconApp.swift
//  macOSBeacon
//
//  Created by griffin-stewie on 2021/12/10.
//  
//

import SwiftUI
import AppFeature
import Beacon

@main
struct macOSBeaconApp: App {

    let peripheral: Peripheral = Peripheral()

    var body: some Scene {
        WindowGroup {
             ContentView()
                 .environmentObject(peripheral.peripheralViewModel)
        }
    }
}
