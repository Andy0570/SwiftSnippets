//
//  SSButton8ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit
import SnapKit

/// 8.提交按钮
final class SSButton8ViewController: UIViewController {
    private var submitButton: UIButton!
    private var saveButton: UIButton!
    
    var saveButtonTappedAction: (()->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "8.提交按钮"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // ------------------------------------
        // submitButton，旧语法
        submitButton = UIButton(type: .system)
        submitButton.setTitle("提交", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.centerX).offset(-20)
            make.centerY.equalToSuperview()
        }
        
        // ------------------------------------
        // saveButton，新语法
        var config = UIButton.Configuration.plain()
        config.title = "Save"
        config.titleAlignment = .center
        config.baseForegroundColor = UIColor.systemBlue
        // 设置内容填充边距
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 7, bottom: 6, trailing: 7)
        // 更新字体大小
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            return outgoing
        })
        saveButton = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.saveButtonTappedAction?()
        })
        // 字体颜色
        saveButton.configurationUpdateHandler = { button in
            switch button.state {
                case .disabled:
                    button.configuration?.baseForegroundColor = UIColor.systemGray
                case .highlighted:
                    button.configuration?.baseForegroundColor = UIColor.systemBlue.darken(by: 0.1)
                default:
                    button.configuration?.baseForegroundColor = UIColor.systemBlue
            }
        }
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.centerX).offset(20)
            make.centerY.equalToSuperview()
        }
    }

    // MARK: - Actions

    @objc private func submitButtonTapped(_ sender: UIButton) {
        showSwiftMessageWithInfo("验证表单，发送网络请求...")
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton8ViewController: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(80)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
