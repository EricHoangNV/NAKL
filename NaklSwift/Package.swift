// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "NAKL",
    platforms: [.macOS(.v15)],
    targets: [
        .executableTarget(
            name: "NAKL",
            path: "NAKL",
            exclude: [
                "Info.plist",
                "NAKL.entitlements",
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "NAKLTests",
            dependencies: ["NAKL"],
            path: "NAKLTests"
        ),
    ]
)
