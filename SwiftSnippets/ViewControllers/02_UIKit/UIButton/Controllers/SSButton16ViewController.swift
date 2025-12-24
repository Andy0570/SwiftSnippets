//
//  SSButton16ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit
import SnapKit

/// 16.带边框线条的圆角按钮（左Label，右Button）
final class SSButton16ViewController: UIViewController {
    // MARK: - Controls
    private var horizontalStackView: UIStackView!
    private var noMeterTagLabel: PaddingLabel!
    private var noMeterButton: UIButton!

    var didTapNoMeterButton: (() -> Void)?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private
extension SSButton16ViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "16.带边框线条的圆角按钮（左Label，右Button）"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // horizontalStackView
        horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fillProportionally
        horizontalStackView.spacing = 4
        view.addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-10)
            // make.width.equalTo(view.snp.width)
        }

        // noMeterTagLabel
        let paddingInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        noMeterTagLabel = PaddingLabel(withContentInsets: paddingInsets)
        noMeterTagLabel.text = "No Meter"
        noMeterTagLabel.textColor = UIColor(hex: "#5E2900")
        noMeterTagLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        noMeterTagLabel.backgroundColor = UIColor(hex: "#FFD9BE")
        noMeterTagLabel.layer.borderWidth = 1.0
        noMeterTagLabel.layer.borderColor = UIColor(hex: "#FFB784").cgColor
        noMeterTagLabel.layer.cornerRadius = 6.0
        noMeterTagLabel.layer.masksToBounds = true
        horizontalStackView.addArrangedSubview(noMeterTagLabel)

        // noMeterButton
        var configuration = UIButton.Configuration.filled()
        configuration.title = "No Meter"
        configuration.baseForegroundColor = UIColor(hex: "#5E2900")
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
        configuration.background.backgroundColor = UIColor(hex: "#FFD9BE")
        configuration.background.strokeColor = UIColor(hex: "#FFB784")
        configuration.background.strokeWidth = 1.0
        configuration.background.cornerRadius = 6.0
        configuration.cornerStyle = .fixed

        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 13, weight: .semibold)
            return outgoing
        })

        noMeterButton = UIButton(configuration: configuration, primaryAction: UIAction { _ in
            self.showSwiftMessageWithInfo("我是按钮")
            self.didTapNoMeterButton?()
        })
        horizontalStackView.addArrangedSubview(noMeterButton)
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton16ViewController: FoxScrollStackContainableController {
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fitLayoutForAxis
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
