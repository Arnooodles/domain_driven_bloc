// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "connectivity_plus", path: "/Users/arnold/.pub-cache/hosted/pub.dev/connectivity_plus-6.1.4/ios/connectivity_plus"),
        .package(name: "device_info_plus", path: "/Users/arnold/.pub-cache/hosted/pub.dev/device_info_plus-11.5.0/ios/device_info_plus"),
        .package(name: "flutter_native_splash", path: "/Users/arnold/.pub-cache/hosted/pub.dev/flutter_native_splash-2.4.6/ios/flutter_native_splash"),
        .package(name: "package_info_plus", path: "/Users/arnold/.pub-cache/hosted/pub.dev/package_info_plus-8.3.0/ios/package_info_plus"),
        .package(name: "path_provider_foundation", path: "/Users/arnold/.pub-cache/hosted/pub.dev/path_provider_foundation-2.4.1/darwin/path_provider_foundation"),
        .package(name: "shared_preferences_foundation", path: "/Users/arnold/.pub-cache/hosted/pub.dev/shared_preferences_foundation-2.5.4/darwin/shared_preferences_foundation"),
        .package(name: "sqflite_darwin", path: "/Users/arnold/.pub-cache/hosted/pub.dev/sqflite_darwin-2.4.2/darwin/sqflite_darwin"),
        .package(name: "url_launcher_ios", path: "/Users/arnold/.pub-cache/hosted/pub.dev/url_launcher_ios-6.3.3/ios/url_launcher_ios")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "connectivity-plus", package: "connectivity_plus"),
                .product(name: "device-info-plus", package: "device_info_plus"),
                .product(name: "flutter-native-splash", package: "flutter_native_splash"),
                .product(name: "package-info-plus", package: "package_info_plus"),
                .product(name: "path-provider-foundation", package: "path_provider_foundation"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "sqflite-darwin", package: "sqflite_darwin"),
                .product(name: "url-launcher-ios", package: "url_launcher_ios")
            ]
        )
    ]
)
