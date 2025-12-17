//
//  MenuButton.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/5.
//

import UIKit

/// 点击按钮时，弹出菜单（iOS 15特性）
/// <https://theswiftdev.com/10-little-uikit-tips-you-should-know/>
class MenuButton: UIButton {
    @available(*, unavailable)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    public init() {
        super.init(frame: .zero)
        setupView()
    }

    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false

        setTitle("Open Menu", for: .normal)
        setTitleColor(.systemGreen, for: .normal)
        showsMenuAsPrimaryAction = true
        menu = getContextMenu()
    }

    private func getContextMenu() -> UIMenu {
        .init(title: "菜单", children: [
            UIAction(title: "编辑", image: UIImage(systemName: "square.and.pencil")) { _ in
                printLog("菜单 - 编辑按钮点击事件")
            },
            UIAction(title: "删除", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                printLog("菜单 - 删除按钮点击事件")
            }
        ])
    }

    func layoutConstraints(in view: UIView) -> [NSLayoutConstraint] {
        [
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 44)
        ]
    }
}
