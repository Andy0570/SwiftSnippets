//
//  SSButton9ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit
import SnapKit

/// 9.渲染图片 tint 值
final class SSButton9ViewController: UIViewController {
    
    // 视频详情页，更多按钮...
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false

        // !!!: 默认图片是黑白色的，这里需要将 tint 值渲染成你想要的颜色
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(named: "navBar_more")?.withTintColor(UIColor.systemPink), for: .normal)
        } else {
            button.setImage(UIImage(named: "navBar_more")?.tint(UIColor.systemPink, blendMode: .destinationIn), for: .normal)
        }

        button.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // 全屏按钮，仅显示图片
    private lazy var fullScreenButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = ColorPalette.fillSecondary
        configuration.baseForegroundColor = ColorPalette.labelPrimary
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
        configuration.image = UIImage(named: "fullscreen").require().withRenderingMode(.alwaysTemplate)
        configuration.cornerStyle = .small
        

        let button = UIButton(configuration: configuration, primaryAction: UIAction { [weak self] _ in
            guard let self else { return }
            showSwiftMessageWithInfo("点击了全屏按钮...")
        })
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "9.渲染图片 tint 值"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // moreButton
        view.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        view.addSubview(fullScreenButton)
        fullScreenButton.snp.makeConstraints { make in
            make.leading.equalTo(moreButton.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
    }

    @objc private func moreButtonTapped(_ sender: UIButton) {
        showSwiftMessageWithInfo("显示分享弹窗...")
    }
}

// MARK: - FoxScrollStackContainableController
extension SSButton9ViewController: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(80)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
