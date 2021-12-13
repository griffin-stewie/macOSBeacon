// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "Beacon", targets: ["Beacon"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "Beacon"
            ]),
        .target(
            name: "Beacon",
            dependencies: [
                
            ]),
        .testTarget(
            name: "PackageTests",
            dependencies: [

            ]),
    ]
)
