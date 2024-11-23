//
//  UIFontExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/10.
//

import UIKit

extension UIFont {
    /// Font as rounded font.
    var rounded: UIFont {
        if #available(iOS 13, tvOS 13, *) {
            guard let descriptor = fontDescriptor.withDesign(.rounded) else {
                return self
            }
            return UIFont(descriptor: descriptor, size: 0)
        } else {
            return self
        }
    }

    /// Font as serif font.
    var serif: UIFont {
        if #available(iOS 13, tvOS 13, *) {
            guard let descriptor = fontDescriptor.withDesign(.serif) else {
                return self
            }
            return UIFont(descriptor: descriptor, size: 0)
        } else {
            return self
        }
    }

    /// Preferred Font with TextStyle and Points.
    static func preferredFont(forTextStyle style: TextStyle, addPoints: CGFloat = .zero) -> UIFont {
        let referensFont = UIFont.preferredFont(forTextStyle: style)
        return referensFont.withSize(referensFont.pointSize + addPoints)
    }

    /// Preferred Font with TextStyle、weight and Points.
    static func preferredFont(forTextStyle style: TextStyle, weight: Weight, addPoints: CGFloat = .zero) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: descriptor.pointSize + addPoints, weight: weight)
        let metrics = UIFontMetrics(forTextStyle: style)
        return metrics.scaledFont(for: font)
    }
}
