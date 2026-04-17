//
//  SSButton18ViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/8.
//

import UIKit

/// 18.复制按钮
final class SSButton18ViewController: UIViewController {
    // MARK: - Controls
    private let batterySnButton1 = UIButton(type: .system)
    private var batterySnButton2: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground

        // titleLabel
        let titleLabel = UILabel.makeForTitle()
        titleLabel.text = "18.复制按钮"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp_leadingMargin)
        }

        // --------------------------------------------
        // batterySnButton1，旧语法
        batterySnButton1.titleLabel?.textColor = UIColor(hex: "#666A76")
        batterySnButton1.titleLabel?.font = .systemFont(ofSize: 15)
        batterySnButton1.setTitle("batterySn", for: .normal)
        let batteryImage = UIImage(named: "bluetooth_line")?.withTintColor(UIColor(hex: "#666A76"))
        batterySnButton1.setImage(batteryImage, for: .normal)
        batterySnButton1.addTarget(self, action: #selector(snButton1DidTapped(_:)), for: .touchUpInside)
        view.addSubview(batterySnButton1)
        batterySnButton1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-10)
        }

        // --------------------------------------------
        // batterySnButton2，新语法
        var config = UIButton.Configuration.plain()
        config.buttonSize = .medium

        // 配置按钮标题样式
        config.title = "SN1234567890"
        config.baseForegroundColor = UIColor(hex: "#666A76")
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 15)
            return outgoing
        })

        // 配置图片
        config.image = UIImage(named: "bluetooth_line")?.withTintColor(UIColor(hex: "#666A76"))
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 14)
        config.imagePadding = 4
        config.imagePlacement = .trailing

        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(snButton2DidTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(batterySnButton1.snp.trailing)
            make.centerY.equalTo(batterySnButton1)
        }
    }

    // MARK: - Action

    @objc private func snButton1DidTapped(_ sender: UIButton) {
        showSwiftMessageWithInfo("复制成功！")
    }

    @objc private func snButton2DidTapped(_ sender: UIButton) {
        showSwiftMessageWithInfo("复制成功！")
    }
}
