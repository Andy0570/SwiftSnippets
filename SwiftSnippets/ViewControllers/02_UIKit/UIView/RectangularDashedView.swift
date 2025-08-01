//
//  RectangularDashedView.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/27.
//

import UIKit

/// Custom view with dashed line border.
///
/// SeeAlso: <https://medium.com/@mail.asifnewaz/dashed-line-border-around-a-uiview-96abb81da560>
final class RectangularDashedView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0

    var dashBorder: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()

        let borderLayer = CAShapeLayer()
        borderLayer.lineWidth = dashWidth
        borderLayer.strokeColor = dashColor.cgColor
        borderLayer.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        if cornerRadius > 0 {
            borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            borderLayer.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(borderLayer)
        self.dashBorder = borderLayer
    }
}
