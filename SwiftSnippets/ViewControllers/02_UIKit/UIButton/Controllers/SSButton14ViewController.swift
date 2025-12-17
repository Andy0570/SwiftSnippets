//
//  SSButton14ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit

/// 14.自定义 Pannel Button
final class SSButton14ViewController: UIViewController {
    // MARK: - Controls

    private let buttonPanelView = ButtonPanelView()
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private

extension SSButton14ViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "14.自定义 Pannel Button"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap!"
        label.sizeToFit()
        view.addSubview(label)

        // buttonPanelView
        buttonPanelView.delegate = self
        view.addSubview(buttonPanelView)
        NSLayoutConstraint.activate([
            buttonPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            buttonPanelView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -10),

            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            label.centerXAnchor.constraint(equalTo: buttonPanelView.centerXAnchor)
        ])
    }
}

// MARK: - ButtonPanelDelegate

extension SSButton14ViewController: ButtonPanelDelegate {
    func didTapButtonWithText(_ text: String) {
        guard text != label.text else {
            return
        }

        label.text = text
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton14ViewController: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(200)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
