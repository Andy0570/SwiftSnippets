//
//  CartPanelView.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/13.
//

import UIKit

/// RaysBooks 示例，购物车结算视图
class CartPanelView: UIView {
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

    /// 水平布局的堆栈视图：costLabel、shippingSpeedButton
    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 10
        return stackView
    }()

    /// 合计金额
    private lazy var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "Cost: $9.41"
        label.textAlignment = .left
        return label
    }()

    /// 物流速度
    private lazy var shippingSpeedButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.buttonSize = .medium
        config.cornerStyle = .medium
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
            return outgoing
        }

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.showsMenuAsPrimaryAction = true

        // 使用弹出菜单的标题作为按钮标题
        button.changesSelectionAsPrimaryAction = true
        button.setTitle("Shipping Speed", for: .normal)

        // 通过 menu 属性设置点击按钮的弹出菜单
        button.menu = UIMenu(children: [
            UIAction(title: "Express Shipping", image: UIImage(systemName: "hare.fill"), handler: { _ in
                printLog("Express Shipping Selected")
            }),
            UIAction(title: "Standard Shipping", image: UIImage(systemName: "tortoise.fill")) { _ in
                printLog("Standard Shipping Selected")
            }
        ])
        return button
    }()

    /// 结账按钮
    private lazy var checkoutButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.cornerStyle = .medium
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
            return outgoing
        }

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        // 使用 configurationUpdateHandler 自动根据结账状态更新按钮样式
        button.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            config?.showsActivityIndicator = self.checkingOut
            config?.title = self.checkingOut ? "Checking Out..." : "Checkout"
            button.isEnabled = !self.checkingOut
            button.configuration = config
        }

        button.configuration = config
        button.setTitle("Checkout", for: .normal)

        button.addAction(
            UIAction { _ in
                self.checkingOut = true

                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    self.checkingOut = false
                }
            },
            for: .touchUpInside
        )

        return button
    }()

    private var checkingOut = false {
        didSet {
            checkoutButton.setNeedsUpdateConfiguration()
        }
    }

    init() {
        super.init(frame: CGRect.zero)

        backgroundColor = .secondarySystemBackground

        addSubview(stackView)
        stackView.addArrangedSubview(informationStackView)

        informationStackView.addArrangedSubview(costLabel)
        informationStackView.addArrangedSubview(shippingSpeedButton)

        stackView.addArrangedSubview(checkoutButton)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 110),

            informationStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            checkoutButton.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
