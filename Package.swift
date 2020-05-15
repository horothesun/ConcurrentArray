// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "ConcurrentArray",
    products: [
        .library(
            name: "ConcurrentArray",
            targets: ["ConcurrentArray"]
        ),
    ],
    targets: [
        .target(
            name: "ConcurrentArray",
            dependencies: []
        ),
        .testTarget(
            name: "ConcurrentArrayTests",
            dependencies: ["ConcurrentArray"]
        ),
    ]
)
