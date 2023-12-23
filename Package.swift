// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-tca-dependency-reminders",
    platforms: [
      .iOS(.v13),
      .macOS(.v10_15),
      .tvOS(.v13),
      .watchOS(.v6),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Reminders",
            targets: ["Reminders"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swipentap/swift-tca-appl.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Reminders",
            dependencies: [
                .product(name: "Appl", package: "swift-tca-appl"),
            ]
        ),
        .testTarget(
            name: "RemindersTests",
            dependencies: ["Reminders"]),
    ]
)
