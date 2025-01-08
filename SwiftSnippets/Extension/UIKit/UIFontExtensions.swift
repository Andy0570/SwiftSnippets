//
//  UIFontExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/10.
//

import UIKit

/// App 字体方案
/// 使用示例：titleLabel.font = UIFont.light(size: Styles.Fonts.regular)
/// 参考：<https://cocoacasts.com/clean-code-with-categories-and-extensions>
extension UIFont {
    // swiftlint:disable force_unwrapping
    static let regular = UIFont(name: "Avenir-Book", size: 12.0)!
    static let light = UIFont(name: "Avenir-Light", size: 12.0)!
    static let bold = UIFont(name: "Avenir-Black", size: 12.0)!

    class func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Book", size: size)!
    }

    class func light(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Light", size: size)!
    }

    class func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Black", size: size)!
    }
    // swiftlint:enable force_unwrapping
}

/// 配置 App 字体字号
/// 使用示例：titleLabel.font = UIFont.light(size: Styles.Fonts.regular)
struct Styles {
    private init() {}

    struct Fonts {
        private init() {}

        static let small: CGFloat = 12.0
        static let regular: CGFloat = 16.0
        static let medium: CGFloat = 20.0
        static let large: CGFloat = 24.0
    }
}

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
