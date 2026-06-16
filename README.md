# Attachment

Embed arbitrary `UIView` subviews inline with text using `NSAttributedString` — mix tags, badges, icons, or any custom views directly into your text content.

![Platform](https://img.shields.io/badge/platform-iOS%2010.0%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.0%2B-orange)
![CocoaPods](https://img.shields.io/badge/CocoaPods-compatible-brightgreen)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

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

- iOS 10.0+
- Swift 5.0+
- Xcode 14+

## License

Attachment is released under the MIT License. See [LICENSE](LICENSE) for details.
