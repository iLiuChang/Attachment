# Attachment

![Swift](https://img.shields.io/badge/Swift-5.0%2B-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2011.0%2B-lightgrey.svg)
![Version](https://img.shields.io/badge/Version-1.1.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![SPM](https://img.shields.io/badge/SPM-supported-brightgreen.svg)
![CocoaPods](https://img.shields.io/badge/CocoaPods-supported-blueviolet.svg)

Embed arbitrary `UIView` subviews inline with text using `NSAttributedString` — mix tags, badges, icons, or any custom views directly into your text content.

## Components

| Component | Base Class | Purpose |
|---|---|---|
| **AttachmentLabel** | `UILabel` | Display with inline views |
| **AttachmentTextView** | `UITextView` | Display with inline views |

## Installation

### CocoaPods

```ruby
pod 'Attachment'
```

Then run:

```bash
pod install
```

### Swift Package Manager

In Xcode: **File → Add Packages…** and enter:

```
https://github.com/iLiuChang/Attachment.git
```

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/iLiuChang/Attachment.git", from: "1.1.0")
]
```

### Manual

1. Download the files in the `Sources` folder
2. Drag them into your Xcode project

## Usage

Both components use `SubviewTextAttachment` to embed a `UIView` into an `NSAttributedString`.

```swift
import Attachment

// 1. Create the view
let tagView = UILabel()
tagView.text = "Host"
tagView.font = .systemFont(ofSize: 11, weight: .semibold)
tagView.textColor = .white
tagView.backgroundColor = .systemRed
tagView.layer.cornerRadius = 3
tagView.layer.masksToBounds = true
tagView.sizeToFit()

// 2. Vertically center on text baseline
let textFont = UIFont.systemFont(ofSize: 14)
let yOffset = ((textFont.capHeight - tagView.frame.height) / 2).rounded()
let bounds = CGRect(x: 0, y: yOffset, width: tagView.frame.width, height: tagView.frame.height)

// 3. Create attachment and build attributed string
let attachment = SubviewTextAttachment(view: tagView, bounds: bounds)

let message = NSMutableAttributedString()
message.append(NSAttributedString(attachment: attachment))
message.append(NSAttributedString(string: " Welcome to the stream!", attributes: [
    .font: textFont,
    .foregroundColor: UIColor.white
]))
```

### SubviewTextAttachment Initializers

```swift
// Init with a view and explicit bounds
SubviewTextAttachment(view: UIView, bounds: CGRect)

// Init with a view, using its current fitting size as the attachment size
SubviewTextAttachment(view: UIView)

// Init with a custom provider for advanced control
SubviewTextAttachment(viewProvider: SubviewTextAttachmentProvider)
```

## Requirements

- iOS 11.0+
- Swift 5.0+

## License

Attachment is released under the MIT License. See [LICENSE](LICENSE) for details.
