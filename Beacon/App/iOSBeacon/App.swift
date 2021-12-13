//
//  iOSBeaconApp.swift
//  iOSBeacon
//
//  Created by griffin-stewie on 2021/12/13.
//  
//

import SwiftUI
import AppFeature
import Beacon

@main
struct MainApp: App {

    let peripheral: Peripheral = Peripheral()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(peripheral.peripheralViewModel)
        }
    }
}
