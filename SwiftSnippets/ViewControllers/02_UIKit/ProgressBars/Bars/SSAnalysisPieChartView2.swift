//
//  SSAnalysisPieChartView2.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/23.
//

import UIKit

/// 环形饼图，通过绘制两段贝塞尔曲线，实现分段绘制效果。
final class SSAnalysisPieChartView2: UIView {
    var primaryColor: UIColor = .gray {
        didSet { setNeedsDisplay() }
    }
    var secondaryColor: UIColor = .clear {
        didSet { setNeedsDisplay() }
    }

    var ringWidth: CGFloat = 8.0

    /// 两段曲线的间隙
    private let visualGapBetweenCaps: CGFloat = 2

    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    private let primaryLayer = CAShapeLayer()
    private let secondaryLayer = CAShapeLayer()
    private let backgroundMask = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    private func setupLayers() {
        // backgroundMask
        backgroundMask.lineWidth = ringWidth
        backgroundMask.fillColor = nil
        backgroundMask.strokeColor = UIColor.black.cgColor
        layer.mask = backgroundMask

        // primaryLayer
        primaryLayer.lineWidth = ringWidth
        primaryLayer.fillColor = nil
        layer.addSublayer(primaryLayer)

        // secondaryLayer
        secondaryLayer.lineWidth = ringWidth
        secondaryLayer.fillColor = nil
        layer.addSublayer(secondaryLayer)

        // 因为默认的绘制起点是 x 轴，这里反向旋转 90 度，调整默认绘制起点在 Y 轴上。
        layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)
    }

    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: ringWidth / 2, dy: ringWidth / 2))
        backgroundMask.path = circlePath.cgPath

        primaryLayer.path = circlePath.cgPath
        primaryLayer.lineCap = .round
        primaryLayer.strokeColor = primaryColor.cgColor

        secondaryLayer.path = circlePath.cgPath
        secondaryLayer.lineCap = .round
        secondaryLayer.strokeColor = secondaryColor.cgColor

        if progress >= 1 {
            primaryLayer.strokeStart = 0
            primaryLayer.strokeEnd = 1
            secondaryLayer.strokeStart = 0
            secondaryLayer.strokeEnd = 0
        } else if progress <= 0 {
            primaryLayer.strokeStart = 0
            primaryLayer.strokeEnd = 0
            secondaryLayer.strokeStart = 0
            secondaryLayer.strokeEnd = 1
        } else {
            /**
             // 当 lineCap = .butt 时，使用此计算方式！
             
             // 与 `circlePath` 一致的中心线半径；strokeStart/End 按该圆周长的比例取值。
             let centerlineRadius = min(rect.width, rect.height) * 0.5
             let circumference = 2 * .pi * centerlineRadius
             // 圆角端帽在端点两侧各伸出约 lineWidth/2；两段之间外缘要留出 visualGap，则中心线端点弧长需多出一整段线宽。
             let gapArcLength = visualGapBetweenCaps
             */

            // 与 `circlePath` 一致的中心线半径；strokeStart/End 按该圆周长的比例取值。
            let centerlineRadius = (min(rect.width, rect.height) - ringWidth) * 0.5
            let circumference = 2 * .pi * centerlineRadius
            // 圆角端帽在端点两侧各伸出约 lineWidth/2；两段之间外缘要留出 visualGap，则中心线端点弧长需多出一整段线宽。
            let gapArcLength = visualGapBetweenCaps + ringWidth

            let gapFraction = gapArcLength / circumference

            let drawableFraction = max(0, 1 - 2 * gapFraction)
            let primaryLength = progress * drawableFraction

            primaryLayer.strokeStart = gapFraction
            primaryLayer.strokeEnd = gapFraction + primaryLength

            secondaryLayer.strokeStart = gapFraction + primaryLength + gapFraction
            secondaryLayer.strokeEnd = 1
        }
    }
}
