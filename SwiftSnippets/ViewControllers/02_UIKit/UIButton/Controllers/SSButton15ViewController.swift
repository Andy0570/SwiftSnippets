//
//  SSButton15ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit
import SnapKit

/// 15.复制文本内容到剪切板
final class SSButton15ViewController: UIViewController {
    // MARK: - Controls
    private var contentLabel: PaddingLabel!
    private var copyButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Actions
    @objc private func copyButtonDidTapped(_ sender: UIButton) {
        guard let content = contentLabel.text, !content.isEmpty else {
            assertionFailure("文本内容为空，无法复制到系统剪切板！")
            return
        }

        // 将文本内容复制到系统剪切板
        UIPasteboard.general.string = content

        // 显示成功的 Toast
        showSwiftMessageWithSuccess("Copied")
    }
}

// MARK: - Private
extension SSButton15ViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "15.复制文本内容到剪切板"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // contentLabel
        contentLabel = PaddingLabel(withContentInsets: .init(top: 9, left: 16, bottom: 9, right: 16))
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.backgroundColor = UIColor.systemGray6
        contentLabel.textColor = UIColor.label
        contentLabel.font = .systemFont(ofSize: 17)
        contentLabel.textAlignment = .natural
        contentLabel.layer.cornerRadius = 10
        contentLabel.layer.masksToBounds = true
        contentLabel.layer.borderColor = UIColor.separator.cgColor
        contentLabel.numberOfLines = 0
        contentLabel.text = "ABCD-ERGI-HIME-8934-SFAE-AFER-RERE-RRRE-$@FD"
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }

        // copyButton
        copyButton = UIButton.makeForCopyButton(title: "Copy")
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.addTarget(self, action: #selector(copyButtonDidTapped(_:)), for: .touchUpInside)
        view.addSubview(copyButton)
        copyButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentLabel)
            make.bottomMargin.equalToSuperview()
        }
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton15ViewController: FoxScrollStackContainableController {
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fitLayoutForAxis
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}

private extension UIButton {
    static func makeForCopyButton(title: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.buttonSize = .medium
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 11, bottom: 9, trailing: 11)

        // 配置按钮标题样式
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            return outgoing
        })

        let button = UIButton(type: .system)
        button.configuration = config
        return button
    }
}
