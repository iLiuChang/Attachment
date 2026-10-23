//
//  AttachmentViewSupport.swift
//  Attachment
//
//  Created by LC on 2026/5/15.
//

import UIKit

func reconcileAttachedViews(_ attachedViews: NSMapTable<SubviewTextAttachment, UIView>,
                            attachments: [SubviewTextAttachment],
                            in containerView: UIView) {
    let currentAttachments = Set(attachments.map(ObjectIdentifier.init))
    let cachedAttachments = attachedViews.keyEnumerator().compactMap { $0 as? SubviewTextAttachment }

    for attachment in cachedAttachments where currentAttachments.contains(ObjectIdentifier(attachment)) == false {
        // The same view may have been moved into another container that now owns it.
        if let view = attachedViews.object(forKey: attachment), view.superview === containerView {
            view.removeFromSuperview()
        }
        attachedViews.removeObject(forKey: attachment)
    }

    for attachment in attachments {
        if let view = attachedViews.object(forKey: attachment) {
            if view.superview == nil {
                hideAttachmentView(view)
                containerView.addSubview(view)
            }
            continue
        }

        let view = attachment.viewProvider.instantiateView(for: attachment, in: containerView)
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = []
        hideAttachmentView(view)
        containerView.addSubview(view)
        attachedViews.setObject(view, forKey: attachment)
    }
}

func hideAttachmentView(_ view: UIView) {
    UIView.performWithoutAnimation {
        view.isHidden = true
    }
}

func layoutAttachmentView(_ view: UIView, origin: CGPoint, size: CGSize, scaleFactor: CGFloat) {
    UIView.performWithoutAnimation {
        view.frame = CGRect(origin: origin.integral(withScaleFactor: scaleFactor), size: size)
        view.isHidden = false
    }
}

extension NSAttributedString {

    var subviewAttachmentRanges: [(attachment: SubviewTextAttachment, range: NSRange)] {
        var ranges = [(SubviewTextAttachment, NSRange)]()

        let fullRange = NSRange(location: 0, length: self.length)
        self.enumerateAttribute(.attachment, in: fullRange) { value, range, _ in
            if let attachment = value as? SubviewTextAttachment {
                ranges.append((attachment, range))
            }
        }

        return ranges
    }

}

extension CGPoint {

    func integral(withScaleFactor scaleFactor: CGFloat) -> CGPoint {
        guard scaleFactor > 0.0 else {
            return self
        }

        return CGPoint(x: round(self.x * scaleFactor) / scaleFactor,
                       y: round(self.y * scaleFactor) / scaleFactor)
    }

}
