//
//  AttachmentLabel.swift
//  Attachment
//
//  Created by LC on 2026/5/14.
//

import UIKit

open class AttachmentLabel: UILabel {

    private let textStorage = NSTextStorage()
    private let layoutManager = NSLayoutManager()
    private let textContainer = NSTextContainer(size: .zero)
    private let attachedViews = NSMapTable<SubviewTextAttachment, UIView>.strongToStrongObjects()
    private var needsTextStorageUpdate = true

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        self.isOpaque = false
        self.textContainer.lineFragmentPadding = 0.0
        self.textStorage.addLayoutManager(self.layoutManager)
        self.layoutManager.addTextContainer(self.textContainer)
    }

    open override var text: String? {
        didSet {
            self.invalidateTextLayout()
        }
    }

    open override var attributedText: NSAttributedString? {
        didSet {
            self.invalidateTextLayout()
        }
    }

    open override var font: UIFont! {
        didSet {
            self.invalidateTextLayout()
        }
    }

    open override var textColor: UIColor! {
        didSet {
            self.invalidateTextLayout()
        }
    }

    open override var textAlignment: NSTextAlignment {
        didSet {
            self.invalidateTextLayout()
        }
    }

    open override var lineBreakMode: NSLineBreakMode {
        didSet {
            self.invalidateTextLayout()
        }
    }

    open override var numberOfLines: Int {
        didSet {
            self.invalidateTextLayout()
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.updateTextContainerSize(self.bounds.size)
        self.updateAttachedSubviews()
        self.layoutAttachedSubviews()
    }

    open override func drawText(in rect: CGRect) {
        self.updateTextContainerSize(rect.size)
        self.updateTextStorageIfNeeded()

        let glyphRange = self.layoutManager.glyphRange(for: self.textContainer)
        guard glyphRange.length > 0 else {
            return
        }

        let offset = self.textDrawingOffset(in: rect)
        self.layoutManager.drawBackground(forGlyphRange: glyphRange, at: offset)
        self.layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: offset)
    }

    // UILabel derives intrinsicContentSize from this method using its Auto Layout width,
    // so multi-line labels wrap correctly without an explicit preferredMaxLayoutWidth.
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let size = self.measuredTextSize(fitting: bounds.size, numberOfLines: numberOfLines)
        return CGRect(origin: bounds.origin, size: size)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.measuredTextSize(fitting: CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude),
                                     numberOfLines: self.numberOfLines)
    }

    private func measuredTextSize(fitting size: CGSize, numberOfLines: Int) -> CGSize {
        let width = size.width > 0.0 && size.width.isFinite ? size.width : CGFloat.greatestFiniteMagnitude
        let height = size.height > 0.0 && size.height.isFinite ? size.height : CGFloat.greatestFiniteMagnitude
        self.updateTextContainerSize(CGSize(width: width, height: height), numberOfLines: numberOfLines)
        self.updateTextStorageIfNeeded()
        self.layoutManager.ensureLayout(for: self.textContainer)
        // Centered or right-aligned lines are offset inside the container, so only the size is meaningful.
        let usedRect = self.layoutManager.usedRect(for: self.textContainer)
        return CGSize(width: ceil(usedRect.width), height: ceil(usedRect.height))
    }

    private func invalidateTextLayout() {
        self.needsTextStorageUpdate = true
        self.setNeedsDisplay()
        self.setNeedsLayout()
        self.invalidateIntrinsicContentSize()
    }

    private func updateTextStorageIfNeeded() {
        guard self.needsTextStorageUpdate else {
            return
        }

        self.needsTextStorageUpdate = false
        self.textStorage.setAttributedString(self.effectiveAttributedText)
        self.updateAttachedSubviews()
    }

    private func updateTextContainerSize(_ size: CGSize, numberOfLines: Int? = nil) {
        self.textContainer.size = CGSize(width: max(size.width, 0.0),
                                         height: max(size.height, 0.0))
        self.textContainer.lineBreakMode = self.lineBreakMode
        self.textContainer.maximumNumberOfLines = numberOfLines ?? self.numberOfLines
    }

    private var effectiveAttributedText: NSAttributedString {
        if let attributedText = self.attributedText, attributedText.length > 0 {
            return attributedText
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.textAlignment
        paragraphStyle.lineBreakMode = self.lineBreakMode

        return NSAttributedString(string: self.text ?? "",
                                  attributes: [
                                      .font: self.font as Any,
                                      .foregroundColor: self.textColor as Any,
                                      .paragraphStyle: paragraphStyle
                                  ])
    }

    private func textDrawingOffset(in rect: CGRect) -> CGPoint {
        self.layoutManager.ensureLayout(for: self.textContainer)
        let usedRect = self.layoutManager.usedRect(for: self.textContainer)
        let y = rect.minY + floor((rect.height - usedRect.height) * 0.5) - usedRect.minY
        return CGPoint(x: rect.minX, y: max(rect.minY, y))
    }

    private func updateAttachedSubviews() {
        self.updateTextStorageIfNeeded()

        let attachments = self.textStorage.subviewAttachmentRanges.map { $0.attachment }
        reconcileAttachedViews(self.attachedViews, attachments: attachments, in: self)
    }

    private func layoutAttachedSubviews() {
        self.updateTextStorageIfNeeded()

        let scaleFactor = self.window?.screen.scale ?? UIScreen.main.scale
        let offset = self.textDrawingOffset(in: self.bounds)

        for (attachment, range) in self.textStorage.subviewAttachmentRanges {
            guard let view = self.attachedViews.object(forKey: attachment), view.superview === self else {
                continue
            }
            guard let rect = self.boundingRect(forAttachmentCharacterAt: range.location) else {
                hideAttachmentView(view)
                continue
            }

            layoutAttachmentView(view,
                                 origin: CGPoint(x: rect.minX + offset.x, y: rect.minY + offset.y),
                                 size: rect.size,
                                 scaleFactor: scaleFactor)
        }
    }

    private func boundingRect(forAttachmentCharacterAt characterIndex: Int) -> CGRect? {
        let glyphRange = self.layoutManager.glyphRange(forCharacterRange: NSRange(location: characterIndex, length: 1),
                                                       actualCharacterRange: nil)
        let glyphIndex = glyphRange.location
        guard glyphIndex != NSNotFound && glyphRange.length == 1 else {
            return nil
        }

        let glyphRect = self.layoutManager.boundingRect(forGlyphRange: glyphRange, in: self.textContainer)
        guard glyphRect.width > 0.0 && glyphRect.height > 0.0 else {
            return nil
        }

        return glyphRect
    }

}
