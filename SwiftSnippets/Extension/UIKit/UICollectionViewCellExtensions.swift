//
//  UICollectionViewCellExtensions.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/5/20.
//

import UIKit

extension UICollectionViewCell {
    /// 为 cell 设置圆角
    func applyRoundedCorners(radius: CGFloat = 10.0) {
        // Apply rounded corners to contentView
        contentView.layer.cornerRadius = radius
        contentView.layer.masksToBounds = true

        // Set masks to bounds to false to avoid the shadow
        // from being clipped to the corner radius
        layer.cornerRadius = radius
        layer.masksToBounds = false
    }

    /// 为 cell 设置部分圆角
    ///
    ///     // 左上角和右上角添加圆角效果
    ///     applyRoundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10.0)
    ///     // 左下角和右下角添加圆角效果
    ///     applyRoundCorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 10.0)
    func applyRoundCorners(_ corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        layer.masksToBounds = true
    }

    /// 还原圆角与阴影
    func resetRoundedCorners() {
        contentView.layer.cornerRadius = 0
        contentView.layer.masksToBounds = false

        layer.cornerRadius = 0
        layer.masksToBounds = true

        layer.shadowColor = nil
        layer.shadowOpacity = 0
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
    }
}
