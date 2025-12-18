//
//  SSMultipleLabelViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/18.
//

import UIKit

/// 仅显示 #15 字体的多行文本
final class SSMultipleLabelViewController: UIViewController {
    private enum Constants {
        static let font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        static let insets = UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 16)
    }
    
    static func cellSize(width: CGFloat, text: String) -> CGSize {
        let cellBounds = TextSize.size(text: text, font: Constants.font, width: width, insets: Constants.insets)
        return cellBounds.size
    }
    
    // MARK: - Controls
    private var titleLabel: UILabel!
    private var titleLabelHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Public
    func configure(with text: String) {
        titleLabel.text = text
        updateViewConstraints()
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        view.height(constant: nil)
    }
    
    override func updateViewConstraints() {
        // 手动计算 titleLabel 的高度
        let fixedWidth = view.frame.size.width - 32
        let newSize = SSMultipleLabelViewController.cellSize(width: fixedWidth, text: titleLabel.text ?? "")
        self.titleLabelHeightConstraint.constant = newSize.height
        
        view.height(constant: nil)
        super.updateViewConstraints()
    }
}

// MARK: = Private
extension SSMultipleLabelViewController {
    private func setupView() {
        view.backgroundColor = UIColor.clear
        
        // titleLabel
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = Constants.font
        titleLabel.textColor = UIColor.secondaryLabel
        titleLabel.textAlignment = .natural
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        // 垂直方向上，titleLabel 多行显示，不压缩高度
//        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 60)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            titleLabelHeightConstraint
        ])
    }
}

// MARK: - FoxScrollStackContainableController
extension SSMultipleLabelViewController {
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
//        let size = CGSizeMake(stackView.bounds.size.width, 300)
//        let bestSize = self.view.systemLayoutSizeFitting(size, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
//        return .fixed(bestSize.height)
         return .fitLayoutForAxis
    }
    
    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
        
    }
}
