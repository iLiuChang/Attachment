//
//  AttachmentViewSupport.swift
//  Attachment
//
//  Created by LC on 2026/5/15.
//

import UIKit

func attachmentProviders(in attachedViews: NSMapTable<AnyObject, UIView>) -> [SubviewTextAttachmentProvider] {
    return Array(attachedViews.keyEnumerator()) as? [SubviewTextAttachmentProvider] ?? []
}

func reconcileAttachedViews(_ attachedViews: NSMapTable<AnyObject, UIView>,
                            attachments: [SubviewTextAttachment],
                            in containerView: UIView) {
    for provider in attachmentProviders(in: attachedViews) {
        if attachments.contains(where: { $0.viewProvider === provider }) == false {
            attachedViews.object(forKey: provider)?.removeFromSuperview()
            attachedViews.removeObject(forKey: provider)
        }
    }

    for attachment in attachments where attachedViews.object(forKey: attachment.viewProvider) == nil {
        let view = attachment.viewProvider.instantiateView(for: attachment, in: containerView)
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = []
        containerView.addSubview(view)
        attachedViews.setObject(view, forKey: attachment.viewProvider)
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
