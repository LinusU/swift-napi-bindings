// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "NAPITests",
    products: [
        .library(name: "NAPITests", type: .dynamic, targets: ["NAPITests"]),
    ],
    dependencies: [
        .package(path: "../"),
    ],
    targets: [
        .target(name: "Trampoline", dependencies: ["NAPIC"]),
        .target(name: "NAPITests", dependencies: ["NAPI", "Trampoline"]),
    ]
)
