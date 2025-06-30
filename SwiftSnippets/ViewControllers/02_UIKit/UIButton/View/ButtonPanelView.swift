//
//  ButtonPanelView.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/5.
//

import UIKit

/// Protocol to handle interactions with buttons in the button panel.
protocol ButtonPanelDelegate: AnyObject {
    /// Notifies the delegate that a button in the panel was tapped.
    /// - Parameter text: The text in the button that was tapped.
    func didTapButtonWithText(_ text: String)
}

/// 自定义可展开按钮
/// 参考：<https://github.com/apatronl/Expandable-Button-Demo>
/// 其他开源框架：<https://github.com/liuzhiyi1992/SpreadButton>
final class ButtonPanelView: UIView {
    private enum Constants {
        static let buttonSize: CGFloat = 56
        static let shadowOpacity: Float = 0.7
    }

    weak var delegate: ButtonPanelDelegate?

    private lazy var menuButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("➕", for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = Constants.buttonSize / 2
        button.addTarget(self, action: #selector(handleTogglePanelButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var dogButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("🐶", for: .normal)
        button.layer.cornerRadius = Constants.buttonSize / 2
        button.isHidden = true
        button.addTarget(self, action: #selector(handleExpandedButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var catButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("🐱", for: .normal)
        button.layer.cornerRadius = Constants.buttonSize / 2
        button.isHidden = true
        button.addTarget(self, action: #selector(handleExpandedButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var expandedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.isHidden = true
        stackView.addArrangedSubview(dogButton)
        stackView.addArrangedSubview(catButton)
        return stackView
    }()

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.addArrangedSubview(expandedStackView)
        stackView.addArrangedSubview(menuButton)
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 81 / 255, green: 166 / 255, blue: 219 / 255, alpha: 1)

        layer.cornerRadius = Constants.buttonSize / 2
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowOffset = .zero

        addSubview(containerStackView)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Main button
            menuButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            menuButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),

            // Dog button
            dogButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            dogButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),

            // Cat button
            catButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            catButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),

            // Container stack view
            containerStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            self.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            self.heightAnchor.constraint(equalTo: containerStackView.heightAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func handleTogglePanelButtonTapped(_ sender: UIButton) {
        let willExpand = expandedStackView.isHidden
        let menuButtonNewTitle = willExpand ? "❌" : "➕"

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.expandedStackView.subviews.forEach { $0.isHidden.toggle() }
            self.expandedStackView.isHidden.toggle()
            if willExpand {
                self.menuButton.setTitle(menuButtonNewTitle, for: .normal)
            }
        } completion: { _ in
            // When collapsing, wait for animation to finish before changing from "x" to "+"
            if !willExpand {
                self.menuButton.setTitle(menuButtonNewTitle, for: .normal)
            }
        }
    }

    @objc private func handleExpandedButtonTapped(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else {
            return
        }
        delegate?.didTapButtonWithText(text)
    }
}
