// swift-tools-version: 5.9
//
// CatchlightAppleStorage: the Apple-platform half of keeping Takes safe on a
// device. The encrypted SQLite TakeStore, the Keychain items for the master key
// and the Privacy phrase, and the English BIP-39 wordlist. Shared by the iPhone
// and Mac apps so their databases and Keychain handling cannot drift.
//
// CatchlightCore stays free of storage and Keychain code; this package is where
// the Apple-only parts live. It takes any Core 2.x (Core 2.0 added the per-Take sync record every TakeStore keeps),
// so each app's exact Core pin decides which Core it builds against, and a Core 2.x release
// needs no release here.
//
import PackageDescription

let package = Package(
    name: "CatchlightAppleStorage",
    platforms: [
        .macOS(.v13),
        .iOS("18.0")
    ],
    products: [
        .library(name: "CatchlightAppleStorage", targets: ["CatchlightAppleStorage"])
    ],
    dependencies: [
        .package(url: "https://github.com/Considus/Catchlight-Core", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(
            name: "CatchlightAppleStorage",
            dependencies: [.product(name: "CatchlightCore", package: "Catchlight-Core")],
            path: "Sources/CatchlightAppleStorage",
            resources: [.copy("Resources/bip39-english.txt")]
        ),
        .testTarget(
            name: "CatchlightAppleStorageTests",
            dependencies: [
                "CatchlightAppleStorage",
                .product(name: "CatchlightCore", package: "Catchlight-Core"),
                .product(name: "CatchlightCoreTestSupport", package: "Catchlight-Core")
            ],
            path: "Tests/CatchlightAppleStorageTests"
        )
    ]
)
