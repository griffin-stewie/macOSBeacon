//
//  BeaconAdvertisementData.swift
//  macOSBeacon
//
//  Created by griffin-stewie on 2021/12/12.
//  
//

import Foundation
import CoreLocation
import CoreBluetooth

public struct BeaconAdvertisementData {
    public let uuid: UUID
    public let major: UInt16
    public let minor: UInt16
    public let measuredPower: Int8

    let beaconKey: String = "kCBAdvDataAppleBeaconKey"

    public init(uuid: UUID, major: UInt16, minor: UInt16, measuredPower: Int8) {
        self.uuid = uuid
        self.major = major
        self.minor = minor
        self.measuredPower = measuredPower
    }

    public init?(uuid: String, major: String, minor: String, measuredPower: String) {
        guard let uuidObj = UUID(uuidString: uuid) else {
            return nil
        }

        guard let majorValue = UInt16(major) else {
            return nil
        }

        guard let minorValue = UInt16(minor) else {
            return nil
        }

        guard let measuredPowerValue = Int8(measuredPower) else {
            return nil
        }

        self.init(uuid: uuidObj, major: majorValue, minor: minorValue, measuredPower: measuredPowerValue)
    }

    public var advertisingData: [String: Any]? {
        #if canImport(UIKit)
        print("iOS: \((advertisingDataForiOS![beaconKey] as! Data).hex())")
        print("macOS: \((advertisingDataFormacOS![beaconKey] as! Data).hex())")

        print(advertisingDataForiOS!)
        print(advertisingDataFormacOS!)
        return advertisingDataForiOS
        #else
        print("macOS: \((advertisingDataFormacOS![beaconKey] as! Data).hex())")
        return advertisingDataFormacOS
        #endif
    }
}

private extension UUID {
    var bytes: [UInt8] {
        return Mirror(reflecting: uuid).children.map({$0.1 as! UInt8}) // converts the tuple into an array
    }

    var data: Data {
        var tmp = self.uuid
        return Data(bytes: &tmp, count: 16)
    }
}

public struct DatatypeConverter {
    public static func parseHexBinary(_ hexString: String) -> Data {
        let bytes = zip(hexString, hexString.dropFirst())
            .enumerated()
            .filter { $0.offset % 2 == 0 }
            .map { String([$0.element.0, $0.element.1]) }
            .compactMap { UInt8($0, radix: 16) }

        return Data(bytes)
    }

    public static func printHexBinary(_ data: Data, uppercased: Bool = false) -> String {
        data.hex(uppercased: uppercased)
    }
}

extension Int8 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Int8>.size)
    }
}

extension UInt8 {
    var data: Data {
        Data([self])
    }
}

extension UInt16 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt16>.size)
    }

    var bigEndianData: Data {
        return CFSwapInt16HostToBig(self).data
    }
}

extension UInt64 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt64>.size)
    }

    var byteArrayLittleEndian: [UInt8] {
        return [
            UInt8((self & 0xFF000000) >> 24),
            UInt8((self & 0x00FF0000) >> 16),
            UInt8((self & 0x0000FF00) >> 8),
            UInt8(self & 0x000000FF)
        ]
    }

    var bigEndianData: Data {
        return CFSwapInt64HostToBig(self).data
    }
}

public extension Data {
    func hex(uppercased: Bool = false) -> String {
        let str = self.map { String(format: "%02hhx", $0) }.joined()
        if uppercased {
            return str.uppercased()
        }
        return str
    }
}

extension BeaconAdvertisementData {
    #if canImport(UIKit)
    var beaconRegion: CLBeaconRegion {
        CLBeaconRegion(uuid: uuid, major: major, minor: minor, identifier: "macOSBeacon")
    }

    var advertisingDataForiOS: [String: Any]? {
        /// `peripheralData(withMeasuredPower:)` works on iOS Platform only.
        let peripheralData = self.beaconRegion.peripheralData(withMeasuredPower: NSNumber(value: measuredPower))
        return ((peripheralData as NSDictionary) as? [String : Any])
    }
    #endif

    var advertisingDataFormacOS: [String: Any]? {
        var data = Data()
        data.append(uuid.data)
        data.append(major.bigEndianData) // need to be Big Endian
        data.append(minor.bigEndianData) // need to be Big Endian
        data.append(measuredPower.data)
        return [beaconKey: data]
    }
}
