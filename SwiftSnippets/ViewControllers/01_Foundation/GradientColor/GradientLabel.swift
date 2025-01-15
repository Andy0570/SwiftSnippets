//
//  GradientLabel.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/3.
//

import UIKit

/// 创建一个 UIStackView 子类作为容器视图，封装 UILabel
final class GradientLabel: UIStackView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        axis = .vertical
        alignment = .center
        addArrangedSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // 在这里为 UILabel 设置渐变色，以匹配正确大小的 bounds。
        let gradient = UIImage.gradientImage(bounds: label.bounds, colors: [.systemBlue, .systemRed])
        label.textColor = UIColor(patternImage: gradient)
    }
}
