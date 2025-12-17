//
//  SSButton1ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit
import SnapKit

/// 1.自定义 outline 按钮（iOS15）
final class SSButton1ViewController: UIViewController {
    // MARK: - Controls

    /// 垂直布局的堆栈视图
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private
extension SSButton1ViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "1.自定义 outline 按钮（iOS15）"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        var configuration = UIButton.Configuration.filled()

        configuration.title = "Normal"
        let normal = OutlineButton(configuration: configuration, primaryAction: nil)

        configuration.title = "Highlighted"
        let highlighted = OutlineButton(configuration: configuration, primaryAction: nil)
        highlighted.isHighlighted = true

        configuration.title = "Selected"
        let selected = OutlineButton(configuration: configuration, primaryAction: nil)
        selected.isSelected = true

        configuration.title = "Highlighted Selected"
        let highlightedSelected = OutlineButton(configuration: configuration, primaryAction: nil)
        highlightedSelected.isHighlighted = true
        highlightedSelected.isSelected = true

        configuration.title = "Disabled"
        let disabled = OutlineButton(configuration: configuration, primaryAction: nil)
        disabled.isEnabled = false

        stackView.addArrangedSubviews([normal, highlighted, selected, highlightedSelected, disabled])
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton1ViewController: FoxScrollStackContainableController {
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fitLayoutForAxis
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
