//
//  PeripheralViewModel.swift
//  macOSBeacon
//
//  Created by griffin-stewie on 2021/12/11.
//  
//

import Foundation

public final class PeripheralViewModel: ObservableObject {
    @Published public var isReady: Bool = false
    @Published public var isAdvertising: Bool = false

    weak var peripheral: Peripheral!

    public func startAdvertise(with model: BeaconAdvertisementData) {
        print("startAdvertise")
        peripheral.startAdvertise(model.advertisingData)
    }

    public func stopAdvertising() {
        print("stopAdvertising")
        peripheral.manager.stopAdvertising()
    }
}
