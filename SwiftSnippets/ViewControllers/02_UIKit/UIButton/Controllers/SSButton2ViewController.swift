//
//  SSButton2ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit
import SnapKit

/// 移出黑名单，旧方法创建的 outlien 样式按钮，没有点击特效
final class SSButton2ViewController: UIViewController {
    // MARK: - Controls
    
    // 旧方法创建的 outlien 样式按钮，没有点击特效
    private(set) lazy var removeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        button.setTitle("移出黑名单", for: .normal)
        button.setTitleColor(UIColor(hexString: "#53CAC3"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.layer.cornerRadius = 2.0
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor(hexString: "#53CAC3")?.cgColor
        button.layer.borderWidth = 1.0
        return button
    }()
    
    // 新语法创建的按钮，可以根据按钮状态更新样式
    private lazy var newRemoveButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "新语法"
        configuration.background.cornerRadius = 2.0
        configuration.background.strokeWidth = 1.0
        configuration.background.strokeColor = UIColor(hexString: "#53CAC3")
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        
        button.configurationUpdateHandler = { button in
            switch button.state {
                case .highlighted:
                    button.configuration?.baseBackgroundColor = UIColor(hexString: "#53CAC3")
                    button.configuration?.baseForegroundColor = UIColor.white
                default:
                    button.configuration?.baseBackgroundColor = UIColor.white
                    button.configuration?.baseForegroundColor = UIColor(hexString: "#53CAC3")
            }
        }
        
        return button
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private
extension SSButton2ViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "2.自定义 outline 按钮"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // removeButton
        view.addSubview(self.removeButton)
        self.removeButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.snp.centerX).offset(-20)
            make.centerY.equalToSuperview()
        }
        
        // newRemoveButton
        view.addSubview(self.newRemoveButton)
        self.newRemoveButton.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp.centerX).offset(20)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton2ViewController: FoxScrollStackContainableController {
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(80)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
