// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PDFViewer",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "PDFViewer",
            targets: ["PDFViewer"]),
    ],
    dependencies: [
        .package(
            name: "ExtensionKit",
            url: "https://github.com/MohammadRezaAnsari/ExtensionKit.git",
            from: "1.7.2"),
    ],
    targets: [
        .target(
            name: "PDFViewer",
            dependencies: [
                "ExtensionKit"
            ],
            resources: [.process("Resources")]),
        .testTarget(
            name: "PDFViewerTests",
            dependencies: ["PDFViewer"]),
    ]
)
