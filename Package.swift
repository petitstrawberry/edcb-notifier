// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "edcb-notifier",
    products: [
        .executable(name: "edcb-notifier",
                    targets: ["edcb-notifier"])
    ],
    dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),

    .package(url: "https://github.com/petitstrawberry/edcb-env-swift.git", from: "0.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "edcb-notifier",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),

                .product(name: "EDCBEnv", package: "edcb-env-swift"),
            ], path: "Sources"
        ),
    ]
)
