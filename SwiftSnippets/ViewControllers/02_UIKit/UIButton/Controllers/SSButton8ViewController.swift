//
//  SSButton8ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit

/// 8.提交按钮
final class SSButton8ViewController: UIViewController {
    private weak var submitButton: UIButton!

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

        // submitButton
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("提交", for: .normal)
        submit.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        view.addSubview(submit)
        submitButton = submit

        NSLayoutConstraint.activate([
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submit.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
