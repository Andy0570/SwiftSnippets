//
//  DesignablePaddingLabel.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/4.
//

import UIKit

/// 支持 Interface Builder 的 PaddingLabel 示例
///
/// Reference: <https://medium.com/fabcoding/add-padding-to-uilabel-in-swift-87ba4647cf05>
@IBDesignable class DesignablePaddingLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 16.0
    @IBInspectable var rightInset: CGFloat = 16.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
