//
//  SSButton10ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit

/// 10.把按钮当成 UILabel 标签使用
final class SSButton10ViewController: UIViewController {
    // 把按钮标签当成普通的文本标签使用
    private(set) lazy var tagsButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitle("标签名称", for: .normal)

        if #available(iOS 13.0, *) {
            button.backgroundColor = UIColor.tertiarySystemGroupedBackground
        } else {
            button.backgroundColor = UIColor(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
        }

        button.layer.masksToBounds = true
        button.layer.cornerRadius = 2

        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        // 标题向右移动 4pt
        // button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)

        button.isUserInteractionEnabled = false
        return button
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "10.把按钮当成 UILabel 标签使用"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // tagsButton
        view.addSubview(tagsButton)
        NSLayoutConstraint.activate([
            tagsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tagsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton10ViewController: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(80)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
