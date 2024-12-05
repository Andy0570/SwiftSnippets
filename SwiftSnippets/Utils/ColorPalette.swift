//
//  ColorPalette.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/11/22.
//

import UIKit
import Hue

/// 纯代码实现的一套 APP 色彩方案，支持深色模式
/// 
/// - SeeAlso: <http://www.chienerrant.com/blog/4190/>
final class ColorPalette {

    /// Easily define two colors for both light and dark mode.
    /// - Parameters:
    ///   - darkColor: The color to use in dark mode.
    ///   - lightColor: The color to use in light mode.
    /// - Returns: A dynamic color that uses both given colors respectively for the given user interface style.
    static func colorWithDarkMode(darkColor: UIColor, lightColor: UIColor) -> UIColor {
        // Return a fallback color for iOS 12 and lower
        guard #available(iOS 13.0, *) else { return lightColor }

        return UIColor.init(dynamicProvider: { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                // Return the color for Dark Mode
                return darkColor
            } else {
                // Return the color for Light Mode
                return lightColor
            }
        })
    }

    static func colorWithDarkMode(darkColorHex: String, lightColorHex: String) -> UIColor {
        return ColorPalette.colorWithDarkMode(darkColor: UIColor(hex: darkColorHex), lightColor: UIColor(hex: lightColorHex))
    }

    static func colorWithUserInterfaceStyle(color: UIColor, with userInterfaceStyle: UIUserInterfaceStyle) -> UIColor {
        guard #available(iOS 13.0, *) else { return color }

        let traitCollection = UITraitCollection(userInterfaceStyle: userInterfaceStyle)
        return color.resolvedColor(with: traitCollection)
    }

    // MARK: - Color Varibles

    static var white: UIColor {
        return self.colorWithDarkMode(darkColorHex: "#000000", lightColorHex: "#ffffff")
    }

    static var black: UIColor {
        return self.colorWithDarkMode(darkColorHex: "#ffffff", lightColorHex: "#000000")
    }

    static var grayLighter: UIColor {
        return self.colorWithDarkMode(darkColorHex: "#242424", lightColorHex: "#ededed")
    }

    static var grayLight: UIColor {
        return self.colorWithDarkMode(darkColorHex: "#4a4a4a", lightColorHex: "#9b9b9b")
    }

    static var grayNormal: UIColor {
        return self.colorWithDarkMode(darkColorHex: "#999999", lightColorHex: "#999999")
    }

    static var grayHeavy: UIColor {
        return self.colorWithDarkMode(darkColorHex: "#9b9b9b", lightColorHex: "#4a4a4a")
    }

    static var grayHeavier: UIColor {
        return self.colorWithDarkMode(darkColorHex: "#ededed", lightColorHex: "#242424")
    }

    static var foreground: UIColor {
        return self.colorWithDarkMode(darkColorHex: "#101010", lightColorHex: "#ffffff")
    }

    static var background: UIColor {
        return self.colorWithDarkMode(darkColorHex: "#000000", lightColorHex: "#f7f7f7")
    }

    static var shadow: UIColor {
        return UIColor.black.alpha(0.09)
    }

    static var overlayer: UIColor {
        return self.colorWithDarkMode(darkColor: UIColor.black.alpha(0.6), lightColor: UIColor.black.alpha(0.4))
    }

    static var red: UIColor {
        return self.colorWithDarkMode(darkColorHex: "#bb055a", lightColorHex: "#bb055a")
    }

    static var orange: UIColor {
        return self.colorWithDarkMode(darkColorHex: "#ce6647", lightColorHex: "#ff7850")
    }

    static var blue: UIColor {
        return self.colorWithDarkMode(darkColorHex: "#429fde", lightColorHex: "#0097ff")
    }

    static var green: UIColor {
        return self.colorWithDarkMode(darkColorHex: "#9aca52", lightColorHex: "#b9ff50")
    }

    static var denim: UIColor {
        return self.colorWithDarkMode(darkColorHex: "#3c5080", lightColorHex: "#3c5080")
    }
}
