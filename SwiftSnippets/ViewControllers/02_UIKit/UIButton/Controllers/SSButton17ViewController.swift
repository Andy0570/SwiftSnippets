//
//  SSButton17ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/3.
//

import UIKit

/// 17.测试把 UIButton 当 cell 使用
final class SSButton17ViewController: UIViewController {
    // MARK: - Controls
    private var menuButton: UIButton!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "17.测试把 UIButton 当 cell 使用"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // menuButton
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Setting"
        configuration.titleAlignment = .leading
        configuration.baseBackgroundColor = UIColor.label
        configuration.background.backgroundColor = UIColor.systemGroupedBackground
        configuration.background.strokeColor = UIColor.black
        configuration.background.strokeWidth = 1.0
        configuration.background.cornerRadius = 10.0
        configuration.cornerStyle = .fixed

        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 17, weight: .regular)
            return outgoing
        })

        // 设置尾部箭头
        configuration.image = UIImage(
            systemName: "chevron.down",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        configuration.imagePlacement = .trailing

        menuButton = UIButton(configuration: configuration, primaryAction: UIAction { [weak self] _ in
            guard let self else { return }
            self.showHideDropMenuView()
        })

        menuButton.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            config?.title = "Tapped!!!"
            button.configuration = config
        }

        view.addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 16, bottom: 5, right: 16))
            make.center.equalToSuperview()
        }
    }

    private func showHideDropMenuView() {
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton17ViewController: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(80)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
