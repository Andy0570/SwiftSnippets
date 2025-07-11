//
//  UIColorExtensions.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/4.
//

import UIKit

// MARK: - HGRippleRadarView 示例
extension UIColor {
    static var lightPink = UIColor(red: 252.0 / 255.0, green: 229.0 / 255.0, blue: 210.0 / 255.0, alpha: 1.0)
    static var lightBlue = UIColor(red: 199.0 / 255.0, green: 234.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
    static var lightGray = UIColor(red: 244.0 / 255.0, green: 243.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
    static var darkYellow = UIColor(red: 237.0 / 255.0, green: 215.0 / 255.0, blue: 164.0 / 255.0, alpha: 1.0)
    static var lightBlack = UIColor(red: 170.0 / 255.0, green: 177.0 / 255.0, blue: 178.0 / 255.0, alpha: 1.0)
}

extension UIColor {
    static let themeColor = UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0)

    /// Generate Random Color.
    class func randomColor(randomAlpha: Bool = false) -> UIColor {
        let redValue = CGFloat(arc4random_uniform(255)) / 255.0
        let greenValue = CGFloat(arc4random_uniform(255)) / 255.0
        let blueValue = CGFloat(arc4random_uniform(255)) / 255.0
        let alphaValue = randomAlpha ? CGFloat(arc4random_uniform(255)) / 255.0 : 1

        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
    }
}
