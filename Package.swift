// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Hermes",
    products: [
        .executable(
            name: "Monkey",
            targets: ["Monkey"]),
        .library(
            name: "MonkeyLang",
            targets: ["MonkeyLang"]),
        .library(
            name: "Hermes",
            targets: ["Hermes"]),
        .library(
            name: "HermesREPL",
            targets: ["HermesREPL"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-tools-support-core.git", from: "0.1.12")
    ],
    targets: [
        .target(
            name: "Monkey",
            dependencies: [
                "Hermes",
                "MonkeyLang",
                "HermesREPL"
            ],
            path: "./Sources/Languages/Monkey/Repl/"),
        .target(
            name: "MonkeyLang",
            dependencies: [
                "Hermes"
            ],
            path: "./Sources/Languages/Monkey/Lib/"),
        .target(
            name: "Hermes",
            dependencies: [],
            path: "./Sources/Hermes/"),
        .target(
            name: "HermesREPL",
            dependencies: [
                .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core")
            ],
            path: "./Sources/HermesREPL/"),
        .testTarget(
            name: "MonkeyTests",
            dependencies: ["MonkeyLang", "Hermes"]),
        .testTarget(
            name: "HermesTests",
            dependencies: ["Hermes"])
    ]
)
