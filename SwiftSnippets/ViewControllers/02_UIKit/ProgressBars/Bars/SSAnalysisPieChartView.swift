//
//  SSAnalysisPieChartView.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/17.
//

import UIKit

/// 环形饼图
final class SSAnalysisPieChartView: UIView {
    var color: UIColor = .gray {
        didSet { setNeedsDisplay() }
    }
    var ringWidth: CGFloat = 14.0

    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    private let progressLayer = CAShapeLayer()
    private let backgroundMask = CAShapeLayer()

    private let startGapLayer = CAShapeLayer()
    private let endGapLayer = CAShapeLayer()

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

        // progressLayer
        progressLayer.lineWidth = ringWidth
        progressLayer.fillColor = nil
        layer.addSublayer(progressLayer)

        for gap in [startGapLayer, endGapLayer] {
            gap.lineWidth = ringWidth
            gap.strokeColor = UIColor.white.cgColor // 模拟的间隙颜色
            gap.fillColor = nil
            gap.lineCap = .butt
            layer.addSublayer(gap)
        }

        // 因为默认的绘制起点是 x 轴，这里反向旋转 90 度，调整默认绘制起点在 Y 轴上。
        layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)
    }

    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: ringWidth / 2, dy: ringWidth / 2))
        backgroundMask.path = circlePath.cgPath

        progressLayer.path = circlePath.cgPath
        progressLayer.lineCap = .butt
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = progress
        progressLayer.strokeColor = color.cgColor

        // 通过在 progressLayer 两端绘制「间隔」模拟饼图效果
        // 如果进度为0或者1，则不添加间隔
        if progress <= 0.01 || progress == 1 {
            startGapLayer.path = circlePath.cgPath
            startGapLayer.strokeStart = 0
            startGapLayer.strokeEnd = 0

            endGapLayer.path = circlePath.cgPath
            endGapLayer.strokeStart = 0
            endGapLayer.strokeEnd = 0
        } else {
            startGapLayer.path = circlePath.cgPath
            startGapLayer.strokeStart = 0.99
            startGapLayer.strokeEnd = 1

            endGapLayer.path = circlePath.cgPath
            endGapLayer.strokeStart = progress - 0.01
            endGapLayer.strokeEnd = progress
        }
    }
}
