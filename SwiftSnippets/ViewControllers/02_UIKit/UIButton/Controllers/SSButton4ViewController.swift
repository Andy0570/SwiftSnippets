//
//  SSButton4ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit
import SnapKit

/// 4.汽车按钮（iOS 15特性）
final class SSButton4ViewController: UIViewController {
    // MARK: - Controls

    private lazy var carButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.cornerStyle = .capsule // 按钮圆角样式，胶囊

        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
            return outgoing
        })

        // 设置按钮尾部汽车图片
        config.image = UIImage(systemName: "car", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.imagePlacement = .trailing
        config.imagePadding = 8.0

        /**
         要改变按钮的外观以响应状态的变化，需要注册一个配置更新处理程序。

         UIButton.ConfigurationUpdateHandler 是一个用来更新按钮配置的闭包：
         typealias ConfigurationUpdateHandler = (UIButton) -> Void
         配置处理程序中设置的任何值都将优先于闭包外部设置的任何值。
         */
        button.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            // 当显示活动指示器时，会替换掉原有的图像
            // config?.showsActivityIndicator = true
            config?.image = button.isHighlighted ? UIImage(systemName: "car.fill") : UIImage(systemName: "car")
            config?.subtitle = self.formatter.string(from: self.range)
            button.configuration = config
        }

        button.configuration = config

        // 按钮点击事件：每次点击按钮，随机更新公里数
        button.addAction(
            UIAction { _ in
                self.range = Measurement(value: Double.random(in: 10...1000), unit: UnitLength.miles)
            }, for: .touchUpInside)

        return button
    }()

    // MARK: - Properties

    private lazy var formatter = MeasurementFormatter()

    private var range = Measurement(value: 100, unit: UnitLength.miles) {
        didSet {
            carButton.setNeedsUpdateConfiguration() // 请求系统更新按钮配置
        }
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private
extension SSButton4ViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "4.汽车按钮（iOS 15特性）"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // carButton
        view.addSubview(carButton)
        carButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton4ViewController: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(80)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
