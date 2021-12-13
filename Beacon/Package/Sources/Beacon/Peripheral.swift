//
//  Peripheral.swift
//  macOSBeacon
//
//  Created by griffin-stewie on 2021/12/10.
//  
//

import CoreBluetooth

public final class Peripheral: NSObject {

    static let serialQueue: DispatchQueue = DispatchQueue(label: "macOSBeacon.serial.queue", qos: .default, attributes: .init(), autoreleaseFrequency: .inherit, target: nil)

    let manager: CBPeripheralManager = CBPeripheralManager(delegate: nil, queue: serialQueue, options: nil)

    private var observers: Array<NSKeyValueObservation> = .init()

    public let peripheralViewModel: PeripheralViewModel = PeripheralViewModel()

    public override init() {
        super.init()
        peripheralViewModel.peripheral = self
        self.manager.delegate = self

        let observer = manager.observe(\.isAdvertising) { manager, _ in
            DispatchQueue.main.async { [weak self] in
                self?.peripheralViewModel.isAdvertising = manager.isAdvertising
            }
        }
        observers.append(observer)
    }

    public func startAdvertise(_ data: [String : Any]?) {
        print(String(describing: data))
        manager.startAdvertising(data)
    }
}

extension Peripheral: CBPeripheralManagerDelegate {
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        DispatchQueue.main.async {
            switch peripheral.state {
            case .poweredOn:
                print("poweredOn")
                self.peripheralViewModel.isReady = true
            case .poweredOff:
                print("poweredOff")
                fallthrough
            case .unauthorized:
                print("unauthorized")
                fallthrough
            case .resetting:
                print("resetting")
                fallthrough
            case .unknown:
                print("unknown")
                fallthrough
            case .unsupported:
                print("unsupported")
                self.peripheralViewModel.isReady = false
            @unknown default:
                fatalError()
            }
        }
    }
}
