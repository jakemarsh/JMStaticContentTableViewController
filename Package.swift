// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JMStaticContentTableViewController",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "JMStaticContentTableViewController",
            targets: ["JMStaticContentTableViewController"]
        ),
    ],
    targets: [
        .target(
            name: "JMStaticContentTableViewController",
            dependencies: [],
            path: "Sources/JMStaticContentTableViewController"
        ),
        .testTarget(
            name: "JMStaticContentTableViewControllerTests",
            dependencies: ["JMStaticContentTableViewController"],
            path: "Tests/JMStaticContentTableViewControllerTests"
        ),
    ]
)
