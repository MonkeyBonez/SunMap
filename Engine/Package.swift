// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SunMapEngine",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "SunMapEngine", targets: ["SunMapEngine"]),
    ],
    targets: [
        .target(name: "SunMapEngine"),
        .executableTarget(name: "suntool", dependencies: ["SunMapEngine"]),
        .testTarget(name: "SunMapEngineTests", dependencies: ["SunMapEngine"],
                    resources: [.copy("Fixtures")]),
    ]
)
