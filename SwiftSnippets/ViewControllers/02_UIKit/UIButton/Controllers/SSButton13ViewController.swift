//
//  SSButton13ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit

/// 13. Details >
final class SSButton13ViewController: UIViewController {
    // MARK: - Controls

    // 使用自定义图片创建 “Detail >” 按钮
    // FIXME: 存在的问题，如何调整图片尺寸？换自带 padding 的图片资源，或者image用 > 代替
    private lazy var detailsButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.buttonSize = .medium

        // 配置按钮标题样式
        config.title = "Detail"
        config.baseForegroundColor = UIColor.secondaryLabel
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 11)
            return outgoing
        })

        // 配置图片
        config.image = UIImage(named: "arrow_right_12x12")?.withTintColor(UIColor.secondaryLabel)
        config.imagePlacement = .trailing

        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(detailsButtonDidTapped(_:)), for: .touchUpInside)
        return button
    }()

    // 使用系统图片创建 “Detail >” 按钮
    private lazy var systemDetailsButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.buttonSize = .small

        // 配置按钮标题样式
        config.title = "Detail"
        config.baseForegroundColor = UIColor(hex: "#9FA2AC")
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 11)
            return outgoing
        })

        // 配置图片
        config.image = UIImage(systemName: "chevron.right")
        // 设置图像大小
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 8)
        // 图像位置与文本间距
        // config.imagePadding = 1
        config.imagePlacement = .trailing

        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(systemDetailsButtonDidTapped(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Actions

    @objc private func detailsButtonDidTapped(_ sender: UIButton) {
        showSwiftMessageWithInfo("Details Button Tapped.")
    }

    @objc private func systemDetailsButtonDidTapped(_ sender: UIButton) {
        showSwiftMessageWithInfo("System Details Button Tapped.")
    }
}

extension SSButton13ViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "13. Details >"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        view.addSubview(detailsButton)
        view.addSubview(systemDetailsButton)

        NSLayoutConstraint.activate([
            detailsButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            detailsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            systemDetailsButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            systemDetailsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton13ViewController: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(80)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
