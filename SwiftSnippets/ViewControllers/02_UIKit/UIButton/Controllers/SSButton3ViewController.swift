//
//  SSButton3ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit
import SnapKit

/// 3.自定义 MenuButton（iOS 15特性）
final class SSButton3ViewController: UIViewController {
    // MARK: - Controls
    private let menuButton = MenuButton()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private
extension SSButton3ViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "3.自定义 MenuButton（iOS15）"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // menuButton
        view.addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton3ViewController: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(80)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
