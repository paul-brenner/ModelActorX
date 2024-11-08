// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "ModelActorX",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ModelActorX",
            targets: ["ModelActorX"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", "509.0.0"..<"601.0.0-prerelease"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .macro(
            name: "ModelActorXMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "ModelActorX",
            dependencies: [
                "ModelActorXMacros",
            ]
        ),
        .testTarget(
            name: "ModelActorXTests",
            dependencies: ["ModelActorX"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
