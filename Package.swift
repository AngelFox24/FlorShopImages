// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "FlorShopImages",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        // 🐘 Fluent driver for Postgres.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.8.0"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        // 🔵 Shared DTOs
        .package(url: "https://github.com/AngelFox24/florshop-dtos", exact: "1.0.17"),
//                .package(path: "../florshop-dtos")
    ],
    targets: [
        .executableTarget(
            name: "FlorShopImages",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "FlorShopDTOs", package: "florshop-dtos"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "FlorShopImagesTests",
            dependencies: [
                .target(name: "FlorShopImages"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
