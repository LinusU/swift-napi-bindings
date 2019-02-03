// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "NAPI",
    products: [
        .library(name: "NAPI", type: .static, targets: ["NAPI"]),
        .library(name: "NAPIC", type: .static, targets: ["NAPIC"]),
    ],
    targets: [
        .target(name: "NAPI", dependencies: ["NAPIC"]),
        .target(name: "NAPIC", publicHeadersPath: "include"),
    ]
)
