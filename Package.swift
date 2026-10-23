// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Attachment",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "Attachment", targets: ["Attachment"])
    ],
    targets: [
        .target(
            name: "Attachment",
            path: "Sources",
            resources: [.copy("PrivacyInfo.xcprivacy")]
        )
    ]
)
