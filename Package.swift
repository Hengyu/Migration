// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Migration",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .macOS(.v11),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "Migration", targets: ["Migration"])
    ],
    targets: [
        .target(name: "Migration"),
        .testTarget(name: "MigrationTests", dependencies: ["Migration"])
    ]
)
