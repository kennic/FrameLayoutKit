// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FrameLayoutKit",
	platforms: [.iOS(.v8), .tvOS(.v9)],
    products: [
        .library(
            name: "FrameLayoutKit",
            targets: ["FrameLayoutKit"]),
    ],
    targets: [
        .target(
            name: "FrameLayoutKit",
			path: "FrameLayoutKit/Classes",
			exclude: ["Example"])
    ],
	swiftLanguageVersions: [.v4_2]
)
