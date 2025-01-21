//
//  Knob.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/20.
//

import UIKit

/// 自定义控件，圆形旋钮
class Knob: UIControl {
    // MARK: - Properties

    var minimumValue: Float = 0
    var maximumValue: Float = 1

    private(set) var value: Float = 0

    func setValue(_ newValue: Float, animated: Bool = false) {
        value = min(maximumValue, max(minimumValue, newValue))

        // 将值转换为角度，再传递给渲染器绘制 UI
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let angleValue = CGFloat(value - minimumValue) / CGFloat(valueRange) * angleRange + startAngle
        renderer.setPointerAngle(angleValue, animated: animated)
    }

    /// 在 value 值更新时触发连续回调，还是仅回调一次
    var isContinuous = true

    // MARK: - 旋钮渲染器以及四个外观属性

    private let renderer = KnobRenderer()

    var lineWidth: CGFloat {
        get { return renderer.lineWidth }
        set { renderer.lineWidth = newValue }
    }

    var startAngle: CGFloat {
        get { return renderer.startAngle }
        set { renderer.startAngle = newValue }
    }

    var endAngle: CGFloat {
        get { return renderer.endAngle }
        set { renderer.endAngle = newValue }
    }

    var pointerLength: CGFloat {
        get { return renderer.pointerLength }
        set { renderer.pointerLength = newValue }
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        renderer.updateBounds(bounds)
    }

    private func commonInit() {
        renderer.updateBounds(bounds)
        renderer.color = tintColor
        renderer.setPointerAngle(renderer.startAngle, animated: false)

        layer.addSublayer(renderer.trackLayer)
        layer.addSublayer(renderer.pointerLayer)

        // 添加自定义旋转手势识别器
        let gestureRecognizer = RotationGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        addGestureRecognizer(gestureRecognizer)
    }

    @objc private func handleGesture(_ gesture: RotationGestureRecognizer) {
        // 计算代表开始角度和结束角度之间中点的角度。这是不属于旋钮轨道的角度，而是表示指针应在最大值和最小值之间翻转的角度。
        let midPointAngle = (2 * CGFloat(Double.pi) + startAngle - endAngle) / 2 + endAngle

        // 手势识别器计算的角度将在 -π 和 π 之间，因为它使用反正切函数。
        // 但是，轨道所需的角度应该在 startAngle 和 endAngle 之间是连续的。
        // 因此，创建一个新的 boundedAngle 变量并对其进行调整以确保它保持在允许的范围内。
        var boundedAngle = gesture.touchAngle
        if boundedAngle > midPointAngle {
            boundedAngle -= 2 * CGFloat(Double.pi)
        } else if boundedAngle < (midPointAngle - 2 * CGFloat(Double.pi)) {
            boundedAngle -= 2 * CGFloat(Double.pi)
        }

        // 更新 boundedAngle 使其位于角度的指定范围内
        boundedAngle = min(endAngle, max(startAngle, boundedAngle))

        // 将旋转角度转换为数值
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let angleValue = Float(boundedAngle - startAngle) / Float(angleRange) * valueRange + minimumValue

        setValue(angleValue)

        // 通过 Target-Action 模式发送通知
        if isContinuous {
            // 每次手势更新时，都触发更新事件
            sendActions(for: .valueChanged)
        } else {
            // 事件应该仅在手势结束或取消时触发
            if gesture.state == .ended || gesture.state == .cancelled {
                sendActions(for: .valueChanged)
            }
        }
    }
}

/// 旋钮渲染器
private class KnobRenderer {
    var color: UIColor = .blue {
        didSet {
            trackLayer.strokeColor = color.cgColor
            pointerLayer.strokeColor = color.cgColor
        }
    }

    var lineWidth: CGFloat = 2 {
        didSet {
            trackLayer.lineWidth = lineWidth
            pointerLayer.lineWidth = lineWidth
            updateTrackLayerPath()
            updatePointerLayerPath()
        }
    }

    var startAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8 {
        didSet {
            updateTrackLayerPath()
        }
    }

    var endAngle: CGFloat = CGFloat(Double.pi) * 3 / 8 {
        didSet {
            updateTrackLayerPath()
        }
    }

    var pointerLength: CGFloat = 6 {
        didSet {
            updateTrackLayerPath()
            updatePointerLayerPath()
        }
    }

    private(set) var pointerAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8

    func setPointerAngle(_ newPointerAngle: CGFloat, animated: Bool = false) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        // 将图层绕 Z 轴旋转指定的角度
        pointerLayer.transform = CATransform3DMakeRotation(newPointerAngle, 0, 0, 1)

        if animated {
            let midAngleValue = (max(newPointerAngle, pointerAngle) - min(newPointerAngle, pointerAngle)) / 2 + min(newPointerAngle, pointerAngle)
            // 关键帧动画，围绕 z 轴旋转
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            // 指定图层应旋转的三个角度：起点、中点和终点
            animation.values = [pointerAngle, midAngleValue, newPointerAngle]
            animation.keyTimes = [0.0, 0.5, 1.0]
            animation.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut)]
            pointerLayer.add(animation, forKey: nil)
        }

        CATransaction.commit()

        pointerAngle = newPointerAngle
    }

    let trackLayer = CAShapeLayer() // 轨道层
    let pointerLayer = CAShapeLayer() // 指针层

    // MARK: - Initializer

    init() {
        trackLayer.fillColor = UIColor.clear.cgColor
        pointerLayer.fillColor = UIColor.clear.cgColor
    }

    func updateBounds(_ bounds: CGRect) {
        trackLayer.bounds = bounds
        trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        updateTrackLayerPath()

        pointerLayer.bounds = trackLayer.bounds
        pointerLayer.position = trackLayer.position
        updatePointerLayerPath()
    }

    private func updateTrackLayerPath() {
        let bounds = trackLayer.bounds
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let offset = max(pointerLength, lineWidth / 2)
        let radius = min(bounds.width, bounds.height) / 2 - offset

        let ring = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        trackLayer.path = ring.cgPath
    }

    private func updatePointerLayerPath() {
        let bounds = trackLayer.bounds

        let pointer = UIBezierPath()
        pointer.move(to: CGPoint(x: bounds.width - CGFloat(pointerLength) - CGFloat(lineWidth) / 2, y: bounds.midY))
        pointer.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))
        pointerLayer.path = pointer.cgPath
    }
}

private class RotationGestureRecognizer: UIPanGestureRecognizer {
    private(set) var touchAngle: CGFloat = 0

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)

        maximumNumberOfTouches = 1
        minimumNumberOfTouches = 1
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        updateAngle(with: touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        updateAngle(with: touches)
    }

    private func updateAngle(with touches: Set<UITouch>) {
        guard let touch = touches.first, let view = view else {
            return
        }

        let touchPoint = touch.location(in: view)
        touchAngle = angle(for: touchPoint, in: view)
    }

    private func angle(for point: CGPoint, in view: UIView) -> CGFloat {
        let centerOffset = CGPoint(x: point.x - view.bounds.midX, y: point.y - view.bounds.midY)
        return atan2(centerOffset.y, centerOffset.x)
    }
}
