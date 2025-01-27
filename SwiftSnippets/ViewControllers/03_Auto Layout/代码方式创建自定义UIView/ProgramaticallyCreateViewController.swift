//
//  ProgramaticallyCreateViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/24.
//

import UIKit

/// 代码方式创建自定义 UIView
/// 参考：
/// * <https://medium.com/@tapkain/custom-uiview-in-swift-done-right-ddfe2c3080a>
/// * <https://tapdev.co/2021/02/05/neatly-organise-complex-programmatic-views-with-a-uiview-subclass/>
class ProgramaticallyCreateViewController: UIViewController {
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("添加自定义视图", for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func addButtonTapped(_ sender: UIButton) {
        let customView = CustomView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.layer.borderColor = UIColor.blue.cgColor
        customView.layer.borderWidth = 2.0
        view.addSubview(customView)

        NSLayoutConstraint.activate([
            customView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
