//
//  BaseView.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/6.
//

import UIKit

/// 视图基类
/// 参考：<https://dilloncodes.com/how-i-organize-layout-code-in-swift>
/// 参考：<https://tapdev.co/2021/02/05/neatly-organise-complex-programmatic-views-with-a-uiview-subclass/>
class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 配置UI
    func setupUI() {
        fatalError("Subclass should implement this method.")
    }

    /// 自动布局约束
    // func setupView() {  }
    // func setupLayout() {  }
    func setupLayout() {
        fatalError("Subclass should implement this method.")
    }
}

extension UIView {
    func addConstrainedSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }

    func addConstrainedSubviews(_ subviews: UIView...) {
        subviews.forEach { addConstrainedSubview($0) }
    }
}

// MARK: - 使用示例

class BasicLayoutView: BaseView {
    private let usernameField = UITextField()
    private let passwordField = UITextField()
    private let submitButton = UIButton(type: .custom)

    override func setupUI() {
    }

    override func setupLayout() {
        addConstrainedSubviews(usernameField, passwordField, submitButton)

        NSLayoutConstraint.activate([
            usernameField.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
            usernameField.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor),

            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 8),
            passwordField.centerYAnchor.constraint(equalTo: centerYAnchor),
            passwordField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            submitButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 8),
            submitButton.centerXAnchor.constraint(equalTo: passwordField.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}

/// <https://dilloncodes.hashnode.dev/ios-view-communication>
class StackViewLayoutView: BaseView {
    private let stackView = UIStackView()
    private let usernameField = UITextField()
    private let passwordField = UITextField()
    private let submitButton = UIButton(type: .custom)

    override func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
    }

    override func setupLayout() {
        addConstrainedSubview(stackView)
        stackView.addArrangedSubviews([usernameField, passwordField, submitButton])

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            passwordField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            usernameField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
