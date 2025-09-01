//
//  PocketSVGUsageController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/8/14.
//

import UIKit

// Framework
import PocketSVG

/**
 通过 SVG 图片，创建 UIBezierPath 贝塞尔曲线路径
 
 GitHub: <https://github.com/pocketsvg/PocketSVG>
 */
class PocketSVGUsageController: UIViewController {
    private(set) lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.0
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemBackground
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 200)
        ])

        // renderSVGWithSVGimageView()

        // renderEachPathOfSVGUsingCAShapeLayer()

        renderEachPathOfSVGUsingCAShapeLayer2()
    }

    // 使用 SVGimageView 渲染 SVG 文件
    private func renderSVGWithSVGimageView() {
        guard let url = Bundle.main.url(forResource: "Vector_68", withExtension: "svg") else {
            fatalError("无法找到指定的 SVG 文件！")
        }

        let svgImageView = SVGImageView(contentsOf: url)
        svgImageView.frame = view.bounds
        svgImageView.contentMode = .scaleAspectFit
        view.addSubview(svgImageView)
    }

    // 官方示例
    // 使用 CAShapeLayer 渲染 SVG 文件中的每一条路径
    private func renderEachPathOfSVGUsingCAShapeLayer() {
        guard let url = Bundle.main.url(forResource: "Vector_68", withExtension: "svg") else {
            fatalError("无法找到指定的 SVG 文件！")
        }

        let paths = SVGBezierPath.pathsFromSVG(at: url)
        let myCustomLayer = CALayer()
        for (index, path) in paths.enumerated() {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            if index % 2 == 0 {
                shapeLayer.strokeColor = UIColor.black.cgColor
            } else {
                shapeLayer.strokeColor = UIColor.red.cgColor
            }
            myCustomLayer.addSublayer(shapeLayer)
        }

        var transform = CATransform3DMakeScale(0.4, 0.4, 1.0)
        transform = CATransform3DTranslate(transform, 200, 400, 0)
        myCustomLayer.transform = transform
        containerView.layer.addSublayer(myCustomLayer)
    }

    // ChatGPT 示例
    // 使用 CAShapeLayer 渲染 SVG 文件中的每一条路径
    private func renderEachPathOfSVGUsingCAShapeLayer2() {
        // 1) 添加静态路径
        // 1.1) 读取 .svg 文件中的所有 <path> 并解析
        guard let url = Bundle.main.url(forResource: "Vector_68", withExtension: "svg") else {
            fatalError("无法找到指定的 SVG 文件！")
        }
        let paths: [UIBezierPath] = SVGBezierPath.pathsFromSVG(at: url)
        printLog("⭐️⭐️⭐️ paths count = \(paths.count)")

        // 1.2) 显示：用 CAShapeLayer 承载 UIBezierPath
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor // 填充色
        shapeLayer.strokeColor = UIColor.systemBlue.cgColor // 线条色
        shapeLayer.lineWidth = 2

        // 多路径可合并为一个 CGMutablePath
        let combined = CGMutablePath()
        paths.forEach { combined.addPath($0.cgPath) }
        shapeLayer.path = combined

        // 1.3) 添加到某个视图上
        containerView.layer.addSublayer(shapeLayer)
        shapeLayer.frame = containerView.bounds

        // 2) 添加电流动画

        // 2.1) 获取贝塞尔曲线路径
        let bezierPath = paths.first

        // 2.2) 创建电流表示的图形（一个小圆）
        let circleLayer = CAShapeLayer()
        circleLayer.frame = CGRect(x: 0, y: 0, side: 2)
        circleLayer.cornerRadius = 1
        circleLayer.backgroundColor = UIColor.green.cgColor // 电流的颜色
        containerView.layer.addSublayer(circleLayer)

        // 2.3) 创建动画沿路径流动
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = bezierPath?.cgPath // 设置路径
        animation.duration = 2.0 // 动画时长（3秒）
        animation.repeatCount = .infinity // 无限循环
        animation.timingFunction = CAMediaTimingFunction(name: .linear) // 线性动画

        // 2.4) 添加动画
        circleLayer.add(animation, forKey: "currentFlow")
    }
}
