//
//  SSButton7ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit
import SnapKit

/// 7.自定义圆角半径（iOS15）
/// 参考：<https://sarunw.com/posts/uikit-rounded-corners-button/>
final class SSButton7ViewController: UIViewController {
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private
extension SSButton7ViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "7.自定义圆角半径（iOS15）"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // roundedCornersButton
        var configuration = UIButton.Configuration.filled()
        configuration.title = "圆角按钮"
        // 设置按钮的背景色
        configuration.baseBackgroundColor = UIColor.systemPink
        // 设置按钮和标题周围的填充
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)

        /**
        1. 使用预定义的 cornerStyle 控制圆角半径

        configuration.cornerStyle = .small
        configuration.cornerStyle = .medium
        configuration.cornerStyle = .large
        configuration.cornerStyle = .capsule
         */
        // configuration.cornerStyle = .large

        /**
         2. 自定义圆角半径
         */
        configuration.background.cornerRadius = 20
        configuration.cornerStyle = .fixed

        let roundedCornersButton = UIButton(configuration: configuration)
        roundedCornersButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(roundedCornersButton)
        NSLayoutConstraint.activate([
            roundedCornersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roundedCornersButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton7ViewController: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(80)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
