// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PersonalityMixer",
    platforms: [
        .iOS(.v18), // Note: Update to .v26 when available
        .macOS(.v15),
        .visionOS(.v2)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PersonalityMixer",
            targets: ["PersonalityMixer"]),
    ],
    dependencies: [
        // No external dependencies - pure SwiftUI
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PersonalityMixer",
            path: "Sources",
            resources: [
                .copy("Resources/PrivacyInfo.xcprivacy")
            ]
        ),
        .testTarget(
            name: "PersonalityMixerTests",
            dependencies: ["PersonalityMixer"],
            path: "Tests"
        ),
    ]
)