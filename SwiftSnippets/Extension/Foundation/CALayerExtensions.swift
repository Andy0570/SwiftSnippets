//
//  CALayerExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/5/5.
//

import UIKit

extension CALayer {
    /// Create a shadow by parameters just like provided in Sketch.
    /// - Parameters:
    ///   - color: Color
    ///   - alpha: Alpha
    ///   - x: x
    ///   - y: y
    ///   - blur: Blur
    ///   - spread: Spread
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            // swiftlint:disable identifier_name
            let dx = -spread
            // swiftlint:enable identifier_name
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
