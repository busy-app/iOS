// swift-tools-version:6.0
import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Macro",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9),
        .macOS(.v13),
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "Macro",
            targets: ["Macro"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            from: "600.0.0")
    ],
    targets: [
        .macro(
            name: "MacroPlugin",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        .target(name: "Macro", dependencies: ["MacroPlugin"]),

        .testTarget(
            name: "MacroTests",
            dependencies: [
                "MacroPlugin",
                .product(
                    name: "SwiftSyntaxMacrosTestSupport",
                    package: "swift-syntax")
            ]
        )
    ]
)
