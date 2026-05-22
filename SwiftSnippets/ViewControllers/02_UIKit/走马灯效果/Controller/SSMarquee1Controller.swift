//
//  SSMarquee1Controller.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/29.
//

import UIKit
import SnapKit

/// 示例1
/// Reference: <https://blog.csdn.net/HDFQQ188816190/article/details/124625470>
final class SSMarquee1Controller: UIViewController {
    private var announceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建一个跑马灯背景
        let background = UIView()
        background.layer.cornerRadius = 6
        background.backgroundColor = .black.withAlphaComponent(0.4)
        self.view.addSubview(background)
        background.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(20)
            make.height.equalTo(50)
            make.bottom.equalTo(-20)
        }

        // 创建一个隐藏的父视图
        let announceBackground = UIView()
        announceBackground.clipsToBounds = true
        background.addSubview(announceBackground)
        announceBackground.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }

        // 创建一个label，用来显示文字并滚动。
        let announceLabel = UILabel()
        announceLabel.textColor = .white
        announceLabel.font = .systemFont(ofSize: 18)
        announceBackground.addSubview(announceLabel)
        announceLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(announceBackground.snp.right) // 让 Label 在父视图右侧开始滚动
        }
        self.announceLabel = announceLabel

        let content = "Your device firmware is outdated. Please upgrade for the best experience."
        showScrollAnimation(content: content)
    }

    func showScrollAnimation(content: String) {
        // 如果没有内容移除动画并隐藏
        if  content.isEmpty {
            announceLabel.layer.removeAllAnimations()
            return
        }

        // 根据文字长度计算一个时间
        self.announceLabel.text = content
        var duration = CGFloat(content.count) / 4.0

        let width = sizeWithText(text: content, font: .systemFont(ofSize: 18), size: .zero)
        let announceBgWidth = UIScreen.main.bounds.width - 32

        if width < announceBgWidth {
            duration = 7
        }

        // 动画
        let animation = CABasicAnimation()
        animation.toValue = -announceBgWidth - width
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        announceLabel.layer.add(animation, forKey: "transform.translation.x")
    }

    // 计算字符串长度
    func sizeWithText(text: String, font: UIFont, size: CGSize) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let width = attributedString.boundingRect(with: size, options: option, context: nil).size.width
        return width
    }
}

// MARK: - FoxScrollStackContainableController
extension SSMarquee1Controller: FoxScrollStackContainableController {
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fitLayoutForAxis
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
