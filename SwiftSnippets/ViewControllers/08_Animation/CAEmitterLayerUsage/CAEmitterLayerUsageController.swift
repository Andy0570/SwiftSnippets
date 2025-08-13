//
//  CAEmitterLayerUsageController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/8/13.
//

import UIKit

/**
 CAEmitterLayer 的使用示例

 参考：<https://juejin.cn/post/6844903534031290376>
 */
final class CAEmitterLayerUsageController: UIViewController, ParticleAnimationable {
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.title = "触发动画效果"
        config.buttonSize = .large
        config.cornerStyle = .dynamic

        // 配置按钮标题样式
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            return outgoing
        })

        // 配置 SF 图片
        config.image = UIImage(named: "bluetooth_line")
        config.imagePadding = 4
        config.imagePlacement = .leading

        button.configuration = config

        // iOS 13.0
        let action = UIAction { [weak self] _ in
            guard let self else { return }

            button.isSelected.toggle()
            let point = CGPoint(x: view.center.x, y: view.center.y + 300)
            button.isSelected ? self.startParticleAnimation(point) : self.stopParticleAnimation()
        }
        button.addAction(action, for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupLayout()

        setupKeyFrameAnimation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopParticleAnimation()
    }

    private func setupView() {
        view.backgroundColor = UIColor.systemBackground

        view.addSubview(self.submitButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            self.submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            self.submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    /**
     在 Swift 中实现电流随着指定贝塞尔曲线流动的动画效果，可以利用 CAShapeLayer 和 CAKeyframeAnimation 来处理路径动画
     */
    private func setupKeyFrameAnimation() {
        // 1. 创建贝塞尔曲线路径
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 50, y: 300)) // 起点
        bezierPath.addCurve(to: CGPoint(x: 350, y: 300), controlPoint1: CGPoint(x: 150, y: 100), controlPoint2: CGPoint(x: 250, y: 500)) // 贝塞尔曲线

        // 2. 创建一个圆形表示电流
        let circleLayer = CAShapeLayer()
        circleLayer.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        circleLayer.cornerRadius = 10
        circleLayer.backgroundColor = UIColor.blue.cgColor // 设置电流颜色
        self.view.layer.addSublayer(circleLayer)

        // 3. 创建沿着路径的动画
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = bezierPath.cgPath // 将路径指定给动画
        animation.duration = 3 // 动画时长
        animation.repeatCount = .infinity // 循环播放
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut) // 设置缓动曲线

        // 4. 添加动画
        circleLayer.add(animation, forKey: "flowingCurrent")
    }
}
