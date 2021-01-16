// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Rosetta",
    products: [
        .executable(
            name: "Monkey",
            targets: ["Monkey"]),
        .library(
            name: "MonkeyLang",
            targets: ["MonkeyLang"]),
        .library(
            name: "Rosetta",
            targets: ["Rosetta"])
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "Monkey",
            dependencies: [
                "Rosetta",
                "MonkeyLang"
            ],
            path: "./Sources/Languages/Monkey/Repl/"),
        .target(
            name: "MonkeyLang",
            dependencies: [
                "Rosetta"
            ],
            path: "./Sources/Languages/Monkey/Lib/"),
        .target(
            name: "Rosetta",
            dependencies: [],
            path: "./Sources/Rosetta/"),
        .testTarget(
            name: "MonkeyTests",
            dependencies: ["MonkeyLang", "Rosetta"]),
        .testTarget(
            name: "RosettaTests",
            dependencies: ["Rosetta"])
    ]
)
