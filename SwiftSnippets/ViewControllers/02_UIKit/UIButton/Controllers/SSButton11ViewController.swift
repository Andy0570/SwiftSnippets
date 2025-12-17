//
//  SSButton11ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit

/// 11.工厂方法
final class SSButton11ViewController: UIViewController {
    private enum Constants {
        static let margin: CGFloat = 20.0
        static let imagePadding: CGFloat = 5.0
    }

    // MARK: - Controls

    private var publishImageButton: UIButton!

    // MARK: - Public

    // 点击“发图文”按钮，执行的回调闭包，'@objc' 关键字可以让这个闭包供外部 Objective-C 类调用
    @objc public var didTapPublishImage: (() -> Void)?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "11.工厂方法"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // publishImageButton
        let imageBtnColor = UIColor(red: 84 / 255.0, green: 234 / 255.0, blue: 222 / 255.0, alpha: 1.0)
        publishImageButton = makePublishButton(title: "发图文", systenImageName: "photo", backgroundColor: imageBtnColor)
        publishImageButton.addTarget(self, action: #selector(publishImageTapped), for: .touchUpInside)
        view.addSubview(publishImageButton)
        NSLayoutConstraint.activate([
            publishImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            publishImageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            publishImageButton.widthAnchor.constraint(equalToConstant: 200),
            publishImageButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Actions

    @objc private func publishImageTapped(_ sender: UIButton) {
        printLog("点击了发图文按钮，打开新的表单页面...")
        self.didTapPublishImage?()
    }
}

// MARK: - Private
extension SSButton11ViewController {
    private func makePublishButton(title: String, systenImageName: String, backgroundColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = backgroundColor
            config.baseForegroundColor = UIColor.black
            config.buttonSize = .large
            config.cornerStyle = .capsule

            // 配置按钮标题样式
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
                var outgoing = incoming
                outgoing.font = UIFont.preferredFont(forTextStyle: .body)
                return outgoing
            })

            // 配置 SF 图片
            config.image = UIImage(systemName: systenImageName)
            config.imagePadding = Constants.imagePadding
            config.imagePlacement = .trailing
            config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
            button.configuration = config
        } else {
            button.backgroundColor = backgroundColor
            button.setTitleColor(UIColor.black, for: .normal)
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            button.layer.cornerRadius = 25.0
            button.layer.masksToBounds = true
        }

        button.setTitle(title, for: .normal)
        return button
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton11ViewController: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(80)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
