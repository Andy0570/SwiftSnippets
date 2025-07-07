//
//  TableFooterView.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/7.
//

import UIKit

class TableFooterView: UIView {
    var lessOrMoreButtonCallback: (() -> Void)?
    var hideButtonCallback: (() -> Void)?

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
        return stackView
    }()

    private var contentLabel: UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }

    private lazy var lessOrMoreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(lessOrMoreButtonPressed), for: .touchUpInside)
        button.setTitle("Less", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    private lazy var hideButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(hideButtonPressed), for: .touchUpInside)
        button.setTitle("Hide", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    init(strings: [String]) {
        super.init(frame: .zero)
        setup(strings: strings)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(strings: [String]) {
        addSubview(contentStackView)

        let leading = contentStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 16)
        leading.priority = UILayoutPriority(999)
        let top = contentStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 8)
        top.priority = UILayoutPriority(999)
        let trailing = layoutMarginsGuide.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: 16)
        trailing.priority = UILayoutPriority(999)
        let bottom = layoutMarginsGuide.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 8)
        bottom.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([
            leading,
            top,
            trailing,
            bottom
        ])

        strings.forEach { string in
            let contentLabel = self.contentLabel
            contentLabel.text = string
            contentStackView.addArrangedSubview(contentLabel)
        }

        contentStackView.addArrangedSubview(lessOrMoreButton)
        contentStackView.addArrangedSubview(hideButton)
        contentStackView.layoutIfNeeded()
    }

    // MARK: - Actions

    // 当 “Less” 按钮被按下时，隐藏/显示 index > 3 的 UILabel
    @objc private func lessOrMoreButtonPressed() {
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut]) {
            self.contentStackView.arrangedSubviews.enumerated().forEach { index, element in
                if index > 3,
                    self.lessOrMoreButton.currentTitle == "Less",
                    element.isKind(of: UILabel.self), !element.isHidden {
                    element.isHidden = true
                } else {
                    element.isHidden = false
                }
            }

            self.contentStackView.layoutIfNeeded()
            self.lessOrMoreButton.setTitle(self.lessOrMoreButton.currentTitle == "Less" ? "More" : "Less", for: .normal)
            self.lessOrMoreButtonCallback?()
        }
    }

    @objc private func hideButtonPressed() {
        let shouldHide = hideButton.currentTitle == "Hide"
        let shouldShowCollpasedState = self.lessOrMoreButton.currentTitle == "More"

        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut]) {
            self.contentStackView.arrangedSubviews.enumerated().forEach { index, element in
                // 当前 element 是否是 “Hide” 按钮（执行隐藏操作时，将它排除在外，永远显示 "Hide" 按钮！）
                var isHideButton = false
                if let button = element as? UIButton, button.currentTitle == "Hide" {
                    isHideButton = true
                }

                func hideElement() {
                    element.isHidden = true
                    // UIStackView 中的按钮必须通过将 isHidden 和 alpha 属性结合起来使用才能执行动画！
                    if element.isKind(of: UIButton.self) {
                        element.alpha = 0
                    }
                }

                func showElement() {
                    element.isHidden = false
                    if element.isKind(of: UIButton.self) {
                        element.alpha = 1
                    }
                }

                if shouldHide {
                    // 应该执行隐藏操作-> 当前 element 未隐藏，且当前 element 不是 “Hide” 按钮，则执行 hideElement 函数
                    if !element.isHidden, !isHideButton {
                        hideElement()
                    }
                } else {
                    // 同步折叠状态
                    if shouldShowCollpasedState {
                        if index > 3, element.isKind(of: UILabel.self) {
                            guard !element.isHidden else { return }
                            hideElement()
                        } else {
                            showElement()
                        }
                    } else {
                        showElement()
                    }
                }
            }

            self.contentStackView.layoutIfNeeded()
            self.hideButton.setTitle(self.hideButton.currentTitle == "Hide" ? "Show" : "Hide", for: .normal)
            self.hideButtonCallback?()
        }
    }
}
