//
//  AttachmentTextView.swift
//  Attachment
//
//  Created by LC on 2024/1/16.
//

import UIKit

open class AttachmentTextView: UITextView, NSLayoutManagerDelegate, NSTextStorageDelegate {

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private let attachedViews = NSMapTable<AnyObject, UIView>.strongToStrongObjects()

    private func commonInit() {
        self.layoutManager.delegate = self
        self.textStorage.delegate = self
    }

    open override var textContainerInset: UIEdgeInsets {
        didSet {
            self.layoutAttachedSubviews()
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutAttachedSubviews()
    }

    open func updateAttachedSubviews() {
        let attachments = self.textStorage.subviewAttachmentRanges.map { $0.attachment }
        reconcileAttachedViews(self.attachedViews, attachments: attachments, in: self)
    }

    open func layoutAttachedSubviews() {
        let scaleFactor = self.window?.screen.scale ?? UIScreen.main.scale

        for (attachment, range) in self.textStorage.subviewAttachmentRanges {
            guard let view = self.attachedViews.object(forKey: attachment.viewProvider) else {
                continue
            }
            guard view.superview === self else {
                continue
            }
            guard let attachmentRect = self.boundingRect(forAttachmentCharacterAt: range.location) else {
                hideAttachmentView(view)
                continue
            }

            let convertedRect = self.convertRectFromTextContainer(attachmentRect)
            layoutAttachmentView(view,
                                 origin: convertedRect.origin,
                                 size: convertedRect.size,
                                 scaleFactor: scaleFactor)
        }
    }

    private func boundingRect(forAttachmentCharacterAt characterIndex: Int) -> CGRect? {
        let glyphRange = self.layoutManager.glyphRange(forCharacterRange: NSMakeRange(characterIndex, 1),
                                                       actualCharacterRange: nil)
        let glyphIndex = glyphRange.location
        guard glyphIndex != NSNotFound && glyphRange.length == 1 else {
            return nil
        }
        guard let textContainer = self.layoutManager.textContainer(forGlyphAt: glyphIndex, effectiveRange: nil) else {
            return nil
        }

        let glyphRect = self.layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        guard glyphRect.width > 0.0 && glyphRect.height > 0.0 else {
            return nil
        }

        return glyphRect
    }

    // MARK: NSLayoutManagerDelegate

    public func layoutManager(_ layoutManager: NSLayoutManager,
                              didCompleteLayoutFor textContainer: NSTextContainer?,
                              atEnd layoutFinishedFlag: Bool) {
        if layoutFinishedFlag {
            self.layoutAttachedSubviews()
        }
    }

    // MARK: NSTextStorageDelegate

    public func textStorage(_ textStorage: NSTextStorage,
                            didProcessEditing editedMask: NSTextStorage.EditActions,
                            range editedRange: NSRange,
                            changeInLength delta: Int) {
        if editedMask.contains(.editedAttributes) || editedMask.contains(.editedCharacters) {
            self.updateAttachedSubviews()
            self.layoutAttachedSubviews()
        }
    }

}

// MARK: - Extensions

private extension UITextView {

    func convertRectFromTextContainer(_ rect: CGRect) -> CGRect {
        let insets = self.textContainerInset
        return rect.offsetBy(dx: insets.left, dy: insets.top)
    }

}
