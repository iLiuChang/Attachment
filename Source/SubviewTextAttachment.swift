//
//  SubviewTextAttachment.swift
//  Attachment
//
//  Created by LC on 2024/1/16.
//

import UIKit

open class SubviewTextAttachment: NSTextAttachment {

    public let viewProvider: SubviewTextAttachmentProvider

    /// Initialize the attachment with a view provider.
    public init(viewProvider: SubviewTextAttachmentProvider) {
        self.viewProvider = viewProvider
        super.init(data: nil, ofType: nil)
    }

    /// Initialize the attachment with a view and an explicit bounds.
    /// - Warning: If an attributed string that includes the returned attachment is used in more than one text view at a time, the behavior is not defined.
    public convenience init(view: UIView, bounds: CGRect) {
        let provider = ViewBackedSubviewTextAttachmentProvider(view: view)
        self.init(viewProvider: provider)
        self.bounds = bounds
    }

    /// Initialize the attachment with a view and use its current fitting size as the attachment size.
    /// - Note: If the view does not define a fitting size, its current bounds size is used.
    /// - Warning: If an attributed string that includes the returned attachment is used in more than one text view at a time, the behavior is not defined.
    public convenience init(view: UIView) {
        self.init(view: view, bounds: CGRect(origin: view.bounds.origin, size: view.textAttachmentFittingSize))
    }

    // MARK: - NSTextAttachmentContainer

    open override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        return self.viewProvider.bounds(for: self, textContainer: textContainer, proposedLineFragment: lineFrag, glyphPosition: position)
    }

    open override func image(forBounds imageBounds: CGRect, textContainer: NSTextContainer?, characterIndex charIndex: Int) -> UIImage? {
        return nil
    }

    // MARK: NSCoding

    public required init?(coder aDecoder: NSCoder) {
        fatalError("SubviewTextAttachment cannot be decoded.")
    }

}

// MARK: - Internal view provider

final internal class ViewBackedSubviewTextAttachmentProvider: SubviewTextAttachmentProvider {

    let view: UIView

    init(view: UIView) {
        self.view = view
    }

    func instantiateView(for attachment: SubviewTextAttachment, in containerView: UIView) -> UIView {
        return self.view
    }

    func bounds(for attachment: SubviewTextAttachment, textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint) -> CGRect {
        return attachment.bounds
    }

}

// MARK: - Extensions

private extension UIView {

    var textAttachmentFittingSize: CGSize {
        let fittingSize = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let intrinsicSize = self.intrinsicContentSize
        let width = max(fittingSize.validDimension, intrinsicSize.validDimension, self.bounds.width)
        let height = max(fittingSize.validDimension(for: \.height), intrinsicSize.validDimension(for: \.height), self.bounds.height)

        if width > 1e-3 && height > 1e-3 {
            return CGSize(width: ceil(width), height: ceil(height))
        }

        return self.bounds.size
    }
    
}

private extension CGSize {

    var validDimension: CGFloat {
        return self.validDimension(for: \.width)
    }

    func validDimension(for keyPath: KeyPath<CGSize, CGFloat>) -> CGFloat {
        let value = self[keyPath: keyPath]
        return value.isFinite && value != UIView.noIntrinsicMetric ? value : 0.0
    }

}
