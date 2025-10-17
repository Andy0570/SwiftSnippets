//
//  SVGPathView.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/9/28.
//

import UIKit

final class SVGPathView: UIView {
    private let shapeLayer = CAShapeLayer()
    private var particleLayers: [CALayer] = []
    private var bezierPath: UIBezierPath?

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(shapeLayer)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds

        // 每次布局变化时都会自动拉伸路径，保证正好填充 bounds
//        if let originalPath = bezierPath {
//            let fitted = fitPathToBounds(originalPath, into: bounds)
//            shapeLayer.path = fitted.cgPath
//            bezierPath = fitted
//        }
    }

    /// 设置 SVG 路径
    func setupSVGPath(svgFileName: String,
                      strokeColor: UIColor = .darkGray,
                      lineWidth: CGFloat = 2.0) {
        // guard let unmanagedPath = PocketSVG.path(fromDAttribute: dAttribute) else { return }

        guard let unmanagedPath = PocketSVG.path(fromSVGFileNamed: svgFileName) else { return }
        // 将 PocketSVG API 返回的 Unmanaged<CGPath> 转换为 CGPath
        let cgPath: CGPath = unmanagedPath.takeUnretainedValue()
        let bezierPath = UIBezierPath(cgPath: cgPath)
        self.bezierPath = bezierPath

        // 使用 CAShapeLayer 显示 SVG 路径（作为底层路径）
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.contentsScale = UIScreen.main.scale
    }

    /// 在路径上添加电流粒子动画：多个小点首尾相接形成尾迹
    func animateCurrent(duration: CFTimeInterval = 2.0,
                        particleColor: UIColor = .green,
                        particleSize: CGFloat = 4,
                        particleCount: Int = 20) {
        guard let path = bezierPath?.cgPath else { return }
        stopCurrentAnimation()

        // 使用 CALayer 绘制粒子，并沿路径做 CAKeyframeAnimation 动画
        let startPoint = path.currentPoint
        for i in 0..<particleCount {
            // 使用圆形 CALayer
            let particle = CALayer()
            particle.bounds = CGRect(x: 0, y: 0, width: particleSize, height: particleSize)
            particle.cornerRadius = particleSize / 2
            particle.position = startPoint
            particle.backgroundColor = particleColor.withAlphaComponent(1.0 - (CGFloat(i) / CGFloat(particleCount))).cgColor
            layer.addSublayer(particle)
            particleLayers.append(particle)

            // 沿路径移动
            let moveAnim = CAKeyframeAnimation(keyPath: "position")
            moveAnim.path = path
            moveAnim.duration = duration
            moveAnim.repeatCount = .infinity
            moveAnim.calculationMode = .paced // 动画速度为匀速
            moveAnim.rotationMode = .rotateAuto // 粒子沿路径方向自动旋转

            // 按粒子数错开开始时间，保证 “电流” 是连续流动的，不会重叠。
            // moveAnim.timeOffset = duration * Double(i) / Double(particleCount)
            moveAnim.beginTime = CACurrentMediaTime() + 0.005 * Double(i)
            moveAnim.timingFunction = CAMediaTimingFunction(name: .linear)
            moveAnim.isRemovedOnCompletion = false
            moveAnim.fillMode = .forwards
            moveAnim.autoreverses = false
            particle.add(moveAnim, forKey: "flow")
        }
    }

    /// 停止动画并移除粒子
    func stopCurrentAnimation() {
        particleLayers.forEach {
            $0.removeAllAnimations()
            $0.removeFromSuperlayer()
        }
        particleLayers.removeAll()
    }

    /// 强制拉伸路径以适配目标 rect
//    private func fitPathToBounds(_ path: UIBezierPath, into rect: CGRect) -> UIBezierPath {
//        let bounds = path.bounds
//        guard bounds.width > 0, bounds.height > 0 else { return path }
//
//        let scaleX = rect.width / bounds.width
//        let scaleY = rect.height / bounds.height
//
//        var transform = CGAffineTransform.identity
//        transform = transform.translatedBy(x: -bounds.minX, y: -bounds.minY) // 先移到 (0,0)
//        transform = transform.scaledBy(x: scaleX, y: scaleY)                 // 拉伸填充
//        transform = transform.translatedBy(x: rect.minX, y: rect.minY)       // 移到目标位置
//
//        let fitted = UIBezierPath(cgPath: path.cgPath)
//        fitted.apply(transform)
//        return fitted
//    }
}
