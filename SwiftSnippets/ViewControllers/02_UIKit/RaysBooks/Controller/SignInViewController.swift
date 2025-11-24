//
//  SignInViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/13.
//

import UIKit

/// RaysBooks 示例，登录页面
final class SignInViewController: UIViewController {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "se_icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var signInButton: UIButton = {
        var config = UIButton.Configuration.filled()
        // 配置按钮大小和圆角
        config.buttonSize = .large
        config.cornerStyle = .medium

        // 配置按钮标题样式
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
            return outgoing
        })

        // 在按钮末尾添加箭头（>）图标
        config.image = UIImage(systemName: "chevron.right")
        // 在标题和图像之间添加 padding 填充距离
        config.imagePadding = 5
        // 将图像放在按钮的末尾
        config.imagePlacement = .trailing
        // 设置 SF 符号的比例为中等
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        // 使用 configurationUpdateHandler 自动根据应用状态更新按钮样式
        button.configurationUpdateHandler = { [unowned self] button in
            // 复制 configuration 并存储在变量中以便修改
            var config = button.configuration
            // 如果用户正在登录，则显示活动指示器。
            config?.showsActivityIndicator = self.signingIn
            // 活动指示器相对于标题的位置和填充基于 imagePlacement 和 imagePadding
            config?.imagePlacement = self.signingIn ? .leading : .trailing
            config?.title = self.signingIn ? "Signing In..." : "Sign In"
            button.isEnabled = !self.signingIn
            button.configuration = config
        }

        button.configuration = config

        button.setTitle("Sign In", for: .normal)
        button.addAction(
            UIAction { _ in
                self.signingIn = true

                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    self.signingIn = false
                }
            },
            for: .touchUpInside
        )
        return button
    }()

    private lazy var helpButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.buttonSize = .large
        config.cornerStyle = .medium

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.setTitle("Get Help", for: .normal)
        button.menu = UIMenu(children: [
            UIAction(title: "Forgot Password", image: UIImage(systemName: "key.fill")) { _ in
                printLog("Forgot Password Tapped")
            },
            UIAction(title: "Contact Support", image: UIImage(systemName: "person.crop.circle.badge.questionmark")) { _ in
                printLog("Contact Support Tapped")
            }
        ])
        button.showsMenuAsPrimaryAction = true
        return button
    }()

    private var signingIn = false {
        didSet {
            // 每当 signingIn 属性更改时，更新按钮配置
            signInButton.setNeedsUpdateConfiguration()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in
            self.dismiss(animated: true)
        })

        view.addSubview(stackView)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(helpButton)

        stackView.setCustomSpacing(125, after: logoImageView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            logoImageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 1 / 4),
            logoImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),

            signInButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            helpButton.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
}
