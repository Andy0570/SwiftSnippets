//
//  UILabelExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2022/9/9.
//

import UIKit

extension UILabel {
    func configureWith(_ text: String, color: UIColor, alignment: NSTextAlignment, size: CGFloat, weight: UIFont.Weight = .regular) {
        self.font = .systemFont(ofSize: size, weight: weight)
        self.text = text
        self.textColor = color
        self.textAlignment = alignment
    }

    /// 为 UILabel 添加下划线效果
    func underLine() {
        if let textUnwrapped = self.text {
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            let underlineAttributedString = NSAttributedString(string: textUnwrapped, attributes: underlineAttribute)
            self.attributedText = underlineAttributedString
        }
    }
}

// MARK: - Factory

extension UILabel {
    /// 表单必填项*
    static func makeForRequiredTag() -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "*"
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }

    /// 标题
    static func makeForTitle() -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .label
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        return label
    }

    /// 子标题
    static func makeForContent() -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        return label
    }
}

// MARK: - Attributed String

extension UILabel {
    /// 设置带单位的富文本，支持不同字体样式（如 5kWh、56℃、10%）
    ///
    /// - 如果 `value` 为空，则仅显示占位符 "--"。
    /// - 如果 `unit` 单位为空，则仅显示 `value` 值。
    func setAttributedText(value: String?,
                           unit: String?,
                           textColor: UIColor,
                           valueFont: UIFont,
                           unitFont: UIFont) {
        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else {
            // assertionFailure("parameter 'value' shoud not be nil or empty.")
            self.text = "--"
            return
        }

        // 如果 unit 为空，则仅显示 value
        let hasUnit = (unit?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false)

        let string = hasUnit ? "\(value) \(unit!)" : value
        let attributedString = NSMutableAttributedString(string: string)

        // value 样式
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .font: valueFont
        ]
        if let range = string.range(of: value) {
            attributedString.addAttributes(valueAttributes, range: NSRange(range, in: string))
        }

        // unit 样式（如果有的话）
        if hasUnit, let unit = unit {
            let unitAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: textColor,
                .font: unitFont
            ]
            if let range = string.range(of: unit) {
                attributedString.addAttributes(unitAttributes, range: NSRange(range, in: string))
            }
        }

        self.attributedText = attributedString
    }
}
