//
//  SSButton5ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit

/// 5.同时兼容 iOS 13~15
final class SSButton5ViewController: UIViewController {
    // MARK: - Controls

    /// 「我要评论..」按钮
    private lazy var commentPencilButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let titleColor = UIColor(red: 128 / 255.0, green: 128 / 255.0, blue: 128 / 255.0, alpha: 1.0)

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.gray()
            config.baseForegroundColor = titleColor
            config.buttonSize = .medium
            config.cornerStyle = .capsule

            // 配置按钮标题样式
            var container = AttributeContainer()
            container.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            // !!!: 在 UIKit 代码中配置下划线样式需要加 '.uikit'
            container.uiKit.underlineStyle = .single
            container.uiKit.underlineColor = titleColor
            config.attributedTitle = AttributedString("我要评论...", attributes: container)
            config.titleAlignment = .leading

            // iOS 13.0, 配置 SF 图片
            config.image = UIImage(systemName: "highlighter")
            config.imagePadding = 5.0
            config.imagePlacement = .leading
            config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 30)

            button.configuration = config

            // iOS 13.0
            let action = UIAction { _ in
                self.didTapCommentPencilButton?()
            }
            button.addAction(action, for: .touchUpInside)
        } else {
            printLog("iOS 15.0 以下系统，降级到旧语法配置按钮样式")

            button.backgroundColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1.0)
            button.setTitle("我要评论...", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.setTitleColor(titleColor, for: .normal)
            button.layer.cornerRadius = 17.0
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(commentPencilButtonTapped(_:)), for: .touchUpInside)
        }

        return button
    }()

    // MARK: - Public

    // 点击"我要评论..."按钮，执行的回调闭包
    var didTapCommentPencilButton: (() -> Void)?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Actions

    // @objc 的作用仅是将 Swift 函数暴露给 Objective-C 调用
    // 由于许多框架仍然使用 Objective-C 编写，即使我们使用 Swift 与它们交互。
    // 因此需要使用 @objc 标注，将该方法暴露给 Objective-C 运行时。
    @objc private func commentPencilButtonTapped(_ sender: UIButton) {
        printLog(#"点击了"我要评论"按钮"#)
        self.didTapCommentPencilButton?()
    }
}

// MARK: - Private
extension SSButton5ViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "5.同时兼容 iOS 13~15"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // commentPencilButton
        view.addSubview(commentPencilButton)
        commentPencilButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton5ViewController: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(80)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
