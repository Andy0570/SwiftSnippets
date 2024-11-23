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
