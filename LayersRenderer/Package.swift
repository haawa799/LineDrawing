// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LayersRenderer",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "LayersRenderer",
            targets: ["LayersRenderer"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "LayersRenderer",
            dependencies: []
        ),
        .testTarget(
            name: "LayersRendererTests",
            dependencies: ["LayersRenderer"]),
    ]
)
