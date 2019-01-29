// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "NAPI",
    products: [
        .library(name: "NAPI", type: .static, targets: ["NAPI"]),
    ],
    targets: [
        .target(name: "NAPI", path: ".", publicHeadersPath: "include"),
    ]
)
