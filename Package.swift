// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Migration",
    platforms: [
        .iOS(.v10),
        .tvOS(.v10),
        .macOS(.v10_10)
    ],
    products: [
        .library(name: "Migration", targets: ["Migration"])
    ],
    targets: [
        .target(name: "Migration"),
        .testTarget(name: "MigrationTests", dependencies: ["Migration"])
    ]
)
