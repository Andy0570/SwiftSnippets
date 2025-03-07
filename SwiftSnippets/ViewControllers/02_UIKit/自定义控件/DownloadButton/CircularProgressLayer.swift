//
//  CircularProgressLayer.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/16.
//

import UIKit

/// 圆型进度指示器
class CircularProgressLayer: CAShapeLayer {
    var progress: CGFloat = 0 {
        didSet {
            update()
        }
    }

    var fillLayer: CAShapeLayer!
    var color: UIColor = .lightGray {
        didSet {
            strokeColor = color.cgColor
            fillLayer.fillColor = color.cgColor
        }
    }

    init(frame: CGRect) {
        super.init()
        self.frame = frame
        setupLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }

    private func setupLayer() {
        isOpaque = false
        lineWidth = 2
        strokeColor = color.cgColor
        fillColor = UIColor.clear.cgColor

        fillLayer = CAShapeLayer()
        fillLayer.fillColor = color.cgColor
        addSublayer(fillLayer)
        update()
    }

    private func update() {
        path = UIBezierPath(ovalIn: bounds).cgPath

        let fillPath = UIBezierPath()
        let radius = frame.size.height / 2
        let center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        fillPath.move(to: center)

        //  |
        //  O -
        //

        let startAngle: CGFloat = -.pi / 2
        let endAngle: CGFloat = (2 * .pi ) * progress + startAngle
        fillPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        fillLayer.path = fillPath.cgPath
    }
}
