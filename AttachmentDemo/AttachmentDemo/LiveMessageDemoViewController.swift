//
//  LiveMessageDemoViewController.swift
//  AttachmentDemo
//
//  Created by Codex on 2026/5/14.
//

import UIKit

final class LiveMessageDemoViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let textFont = UIFont.systemFont(ofSize: 14.0)
    private var messages = [(tags: [DemoTag], text: String)]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 0.07, green: 0.08, blue: 0.10, alpha: 1.0)
        self.configureMessageList()
        self.reloadMessages()
        
        let textView = AttachmentTextView()
        textView.backgroundColor = .clear
        textView.frame = CGRect(x: 0, y: 100, width:view.frame.width, height: 100)
        view.addSubview(textView)
        let atts = NSMutableAttributedString()
        messages.forEach {
            atts.append(makeMessageText($0.text, tags: $0.tags))
            atts.append(NSAttributedString(string: "\n"))
        }
        textView.attributedText = atts

    }

    private func configureMessageList() {
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.alwaysBounceVertical = true
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 32.0
        self.tableView.contentInset = UIEdgeInsets(top: 24.0, left: 0.0, bottom: 24.0, right: 0.0)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseIdentifier)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.heightAnchor.constraint(equalToConstant: 200),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func reloadMessages() {
        self.messages = [
            ([.init(text: "房管", backgroundColor: UIColor(red: 0.16, green: 0.48, blue: 0.92, alpha: 1.0)),
              .init(text: "Lv.18", backgroundColor: UIColor(red: 0.92, green: 0.43, blue: 0.18, alpha: 1.0))],
             "阿澈：这一波操作太细了，主播直接拉满。"),
            ([.init(text: "主播", backgroundColor: UIColor(red: 0.86, green: 0.22, blue: 0.35, alpha: 1.0))],
             "欢迎新进直播间的朋友，点点关注不迷路。"),
            ([.init(text: "贵宾", backgroundColor: UIColor(red: 0.50, green: 0.30, blue: 0.88, alpha: 1.0)),
              .init(text: "守护", backgroundColor: UIColor(red: 0.14, green: 0.62, blue: 0.53, alpha: 1.0))],
             "墨白：这个 AttachmentLabel 支持多标签和长文本自动换行，用在公屏消息里正合适。"),
            ([.init(text: "新人", backgroundColor: UIColor(red: 0.19, green: 0.58, blue: 0.36, alpha: 1.0))],
             "青柠：刚进来，发生什么了？"),
            ([.init(text: "粉丝团", backgroundColor: UIColor(red: 0.84, green: 0.33, blue: 0.70, alpha: 1.0)),
              .init(text: "Lv.6", backgroundColor: UIColor(red: 0.25, green: 0.49, blue: 0.91, alpha: 1.0))],
             "小北：这把节奏好快，字幕和标签混排看起来也很稳。"),
            ([.init(text: "管理员", backgroundColor: UIColor(red: 0.13, green: 0.44, blue: 0.78, alpha: 1.0))],
             "请大家文明发言，不要刷屏。"),
            ([.init(text: "SVIP", backgroundColor: UIColor(red: 0.93, green: 0.59, blue: 0.16, alpha: 1.0)),
              .init(text: "榜一", backgroundColor: UIColor(red: 0.90, green: 0.22, blue: 0.27, alpha: 1.0))],
             "山海：主播这个连招我学会了，等我去训练场试一下。"),
            ([.init(text: "房管", backgroundColor: UIColor(red: 0.16, green: 0.48, blue: 0.92, alpha: 1.0))],
             "阿澈：后面的朋友看这里，当前演示的是 UIView 作为附件插入文本。"),
            ([.init(text: "贵宾", backgroundColor: UIColor(red: 0.50, green: 0.30, blue: 0.88, alpha: 1.0))],
             "云舟：长消息也可以继续换行，比如这一条会占两行，主要用来观察标签在多行文本第一行里的位置是否稳定。"),
            ([.init(text: "主播", backgroundColor: UIColor(red: 0.86, green: 0.22, blue: 0.35, alpha: 1.0)),
              .init(text: "公告", backgroundColor: UIColor(red: 0.30, green: 0.30, blue: 0.34, alpha: 1.0))],
             "下一局马上开始，大家可以继续在公屏里发问题。"),
            ([.init(text: "Lv.22", backgroundColor: UIColor(red: 0.92, green: 0.43, blue: 0.18, alpha: 1.0))],
             "无声：这个列表滚动起来以后，复用同一类 AttachmentLabel 就够了。"),
            ([.init(text: "守护", backgroundColor: UIColor(red: 0.14, green: 0.62, blue: 0.53, alpha: 1.0)),
              .init(text: "连麦", backgroundColor: UIColor(red: 0.41, green: 0.35, blue: 0.86, alpha: 1.0))],
             "南星：我这边看标签宽度和文字都正常，滚动时也不会跳。"),
            ([.init(text: "新人", backgroundColor: UIColor(red: 0.19, green: 0.58, blue: 0.36, alpha: 1.0)),
              .init(text: "首评", backgroundColor: UIColor(red: 0.80, green: 0.39, blue: 0.20, alpha: 1.0))],
             "一颗糖：第一次发言，测试一下短文本。"),
            ([.init(text: "粉丝团", backgroundColor: UIColor(red: 0.84, green: 0.33, blue: 0.70, alpha: 1.0))],
             "鹿鸣：如果后面要接 tableView 或 collectionView，这个 attributedText 构造方式也能迁过去。")
        ]

        self.tableView.reloadData()
    }

    private func makeMessageText(_ text: String, tags: [DemoTag]) -> NSAttributedString {
        let result = NSMutableAttributedString()

        for tag in tags {
            let tagView = DemoTagView(tag: tag)
            let fittingSize = tagView.intrinsicContentSize.integral
            tagView.bounds = CGRect(origin: .zero, size: fittingSize)
            let bounds = CGRect(origin: CGPoint(x: 0, y: (textFont.capHeight - tagView.frame.height).rounded() / 2), size: tagView.frame.size).integral
            let attachment = SubviewTextAttachment(view: tagView, bounds: bounds)
            result.append(NSAttributedString(attachment: attachment))
            result.append(NSAttributedString(string: " "))
        }

        result.append(NSAttributedString(string: text,
                                         attributes: [
                                             .font: self.textFont,
                                             .foregroundColor: UIColor(white: 0.95, alpha: 1.0)
                                         ]))
        
        let tagView = UIImageView(image: UIImage(systemName: "basketball.fill"))
        tagView.sizeToFit()
        let bounds = CGRect(origin: CGPoint(x: 0, y: (textFont.capHeight - tagView.frame.height).rounded() / 2), size: tagView.frame.size).integral
        let attachment = SubviewTextAttachment(view: tagView, bounds: bounds)
        result.append(NSAttributedString(attachment: attachment))

        return result
    }

}

extension LiveMessageDemoViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseIdentifier, for: indexPath) as! MessageCell
        let message = self.messages[indexPath.row]
        cell.configure(attributedText: self.makeMessageText(message.text, tags: message.tags),
                       preferredMaxLayoutWidth: tableView.bounds.width - 32.0)
        return cell
    }

}

private final class MessageCell: UITableViewCell {

    static let reuseIdentifier = "MessageCell"

    private let messageLabel = AttachmentLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.messageLabel.attributedText = nil
    }

    func configure(attributedText: NSAttributedString, preferredMaxLayoutWidth: CGFloat) {
        self.messageLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth
        self.messageLabel.attributedText = attributedText
    }

    private func commonInit() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none

        self.messageLabel.numberOfLines = 0
        self.messageLabel.font = .systemFont(ofSize: 14.0)
        self.messageLabel.textColor = .white
        self.messageLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        self.messageLabel.setContentHuggingPriority(.required, for: .vertical)
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(self.messageLabel)

        NSLayoutConstraint.activate([
            self.messageLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0),
            self.messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -16.0),
            self.messageLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4.0),
            self.messageLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4.0)
        ])
    }

}

private struct DemoTag {
    var text: String
    var textColor: UIColor = .white
    var backgroundColor: UIColor
}

private final class DemoTagView: UILabel {

    private let contentInsets = UIEdgeInsets(top: 2.0, left: 5.0, bottom: 2.0, right: 5.0)

    init(tag: DemoTag) {
        super.init(frame: .zero)
        self.text = tag.text
        self.font = .systemFont(ofSize: 11.0, weight: .semibold)
        self.textColor = tag.textColor
        self.backgroundColor = tag.backgroundColor
        self.lineBreakMode = .byClipping
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("DemoTagView cannot be decoded.")
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + self.contentInsets.left + self.contentInsets.right,
                      height: size.height + self.contentInsets.top + self.contentInsets.bottom)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.contentInsets))
    }

}


private extension CGSize {

    var integral: CGSize {
        return CGSize(width: ceil(self.width), height: ceil(self.height))
    }

    func baselineCenteredAttachmentY(for font: UIFont) -> CGFloat {
        return (self.height - font.ascender - font.descender) * 0.5
    }

}
