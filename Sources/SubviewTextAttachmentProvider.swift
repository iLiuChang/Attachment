//
//  SubviewTextAttachmentProvider.swift
//  Attachment
//
//  Created by LC on 2024/1/16.
//

import UIKit

public protocol SubviewTextAttachmentProvider: AnyObject {

    /// Returns a view that corresponds to the specified attachment.
    /// - Note: The container view caches instantiated views until the attachment leaves the text container.
    func instantiateView(for attachment: SubviewTextAttachment, in containerView: UIView) -> UIView

    /// Returns the layout bounds of the view that corresponds to the specified attachment.
    /// - Note: Return `attachment.bounds` for default behavior. See `NSTextAttachmentContainer.attachmentBounds(for:, proposedLineFragment:, glyphPosition:, characterIndex:)` method for more details.
    func bounds(for attachment: SubviewTextAttachment, textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint) -> CGRect

}
