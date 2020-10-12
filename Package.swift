// swift-tools-version:5.3
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
        .target(
            name: "Migration",
            path: "Migration",
            exclude: ["Info.plist", "Migration.h"]
        ),
        .testTarget(
            name: "MigrationTests",
            dependencies: ["Migration"],
            path: "MigrationTests",
            exclude: ["Info.plist"]
        )
    ]
)
