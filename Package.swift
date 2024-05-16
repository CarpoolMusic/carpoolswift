// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MusicQueue",
    platforms: [
        .iOS(.v16), // Specify minimum iOS version
        .macOS(.v12) // Specify minimum macOS version
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MusicQueue",
            targets: ["MusicQueue"]),
    ],
    dependencies: [
        // Update dependencies to use the non-deprecated API for specifying branches.
        .package(url: "https://github.com/socketio/socket.io-client-swift", .upToNextMinor(from: "15.0.0")),
        .package(url: "https://github.com/evgenyneu/keychain-swift", from: "20.0.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "2.0.0")

    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MusicQueue",
            dependencies: [
                .product(name: "SocketIO", package: "socket.io-client-swift"), 
                .product(name: "KeychainSwift", package: "keychain-swift"),
                "SpotifyiOS"
                ], 
                path: "./MusicQueue"
        ),
        .binaryTarget(
            name: "SpotifyiOS",
            path: "./MusicQueue/SpotifyiOS.xcframework" // Path to the local .xcframework
        ),
        .testTarget(
            name: "MusicQueueTests",
            dependencies: [],
            path: "./MusicQueueTests"),
    ]
)
