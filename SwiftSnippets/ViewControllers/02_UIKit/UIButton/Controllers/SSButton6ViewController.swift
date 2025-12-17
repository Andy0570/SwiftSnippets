//
//  SSButton6ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit
import SnapKit

/// 6.电商示例，在结账按钮中显示购买商品总数（iOS15）
final class SSButton6ViewController: UIViewController {
    // MARK: - Controls

    // 添加按钮，模拟添加商品
    private lazy var addButton: UIButton = {
        let addButton = UIButton(configuration: .gray(), primaryAction: UIAction(handler: { [unowned self] _ in
            itemCount += 1
        }))
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("Add Item", for: .normal)
        return addButton
    }()

    /// 结账按钮
    private lazy var checkoutButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemPink
        configuration.buttonSize = .large

        // checkout 结账按钮
        let checkoutButton = UIButton(configuration: configuration, primaryAction: nil)
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.configurationUpdateHandler = { [unowned self] button in
            button.configuration?.title = "Checkout \(itemCount)"
        }
        return checkoutButton
    }()

    // MARK: - Prpoerties

    private var itemCount: Int = 0 {
        didSet {
            checkoutButton.setNeedsUpdateConfiguration()
        }
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private
extension SSButton6ViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "6.电商示例，在结账按钮中显示购买商品总数（iOS15）"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // addButton
        view.addSubview(self.addButton)
        self.addButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(view.snp.centerX).offset(-10)
        }

        // checkoutButton
        view.addSubview(self.checkoutButton)
        self.checkoutButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(view.snp.centerX).offset(10)
        }
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton6ViewController: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(80)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
