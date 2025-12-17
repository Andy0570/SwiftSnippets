//
//  SSButton12ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit

/// 12.工厂方法
final class SSButton12ViewController: UIViewController {
    private enum Constants {
        static let margin: CGFloat = 20.0
        static let imagePadding: CGFloat = 5.0
    }

    // MARK: - Controls

    private var bluetoothButton: UIButton!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension SSButton12ViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "12.工厂方法"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // bluetoothButton
        bluetoothButton = makeBluetoothButton(title: "Enable Bluetooth")
        view.addSubview(bluetoothButton)
        NSLayoutConstraint.activate([
            bluetoothButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bluetoothButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // 通过工厂方法创建按钮
    private func makeBluetoothButton(title: String) -> UIButton {
        if #available(iOS 15.0, *) {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            var config = UIButton.Configuration.filled()
            config.title = title
            config.buttonSize = .large
            config.cornerStyle = .medium

            // 配置按钮标题样式
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                return outgoing
            })

            // 配置 SF 图片
            config.image = UIImage(named: "bluetooth_line")
            config.imagePadding = 4
            config.imagePlacement = .leading

            button.configuration = config

            return button
        } else {
            let button = UIButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false

            button.backgroundColor = UIColor.systemBlue
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            button.setImage(UIImage(named: "bluetooth_line"), for: .normal)
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
            button.contentEdgeInsets = UIEdgeInsets(top: 13, left: 15, bottom: 13, right: 15)

            return button
        }
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton12ViewController: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(80)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
