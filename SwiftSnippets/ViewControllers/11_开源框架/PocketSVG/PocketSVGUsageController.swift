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
//        view.addSubview(containerView)
//        NSLayoutConstraint.activate([
//            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            containerView.heightAnchor.constraint(equalToConstant: 200)
//        ])

        // renderSVGWithSVGimageView()

        // renderEachPathOfSVGUsingCAShapeLayer()

        // renderEachPathOfSVGUsingCAShapeLayer2()

        renderEachPathOfSVGUsingCAShapeLayer3()
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
        shapeLayer.fillColor = UIColor.clear.cgColor // 整个平面的填充色
        shapeLayer.strokeColor = UIColor.darkGray.cgColor // 线条色
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

        // 手动绘制贝塞尔曲线路径
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 2, y: 2.20605))
        path.addLine(to: CGPoint(x: 2, y: 78.9131))
        path.addCurve(to: CGPoint(x: 1.25, y: 79.6631),
                      controlPoint1: CGPoint(x: 1.99987, y: 79.3272),
                      controlPoint2: CGPoint(x: 1.66413, y: 79.6631))
        path.addCurve(to: CGPoint(x: 0.5, y: 78.9131),
                      controlPoint1: CGPoint(x: 0.835868, y: 79.6631),
                      controlPoint2: CGPoint(x: 0.50013, y: 79.3272))
        path.addLine(to: CGPoint(x: 0.5, y: 0.15625))
        path.addLine(to: CGPoint(x: 2, y: 2.20605))
        path.close()


        // let bezierPath = paths.first
        let bezierPath = path

        // 2.2) 创建电流表示的图形（一个小圆）
        let circleLayer = CAShapeLayer()
        circleLayer.frame = CGRect(x: 0, y: 0, side: 2)
        circleLayer.cornerRadius = 1
        circleLayer.backgroundColor = UIColor.green.cgColor // 电流的颜色
        containerView.layer.addSublayer(circleLayer)

        // 2.3) 创建动画沿路径流动
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = bezierPath.cgPath // 将路径指定给动画
        animation.duration = 2.0 // 动画时长（3秒）
        animation.repeatCount = .infinity // 无限循环
        animation.timingFunction = CAMediaTimingFunction(name: .linear) // 线性动画
        // animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut) // 缓动曲线

        // 2.4) 添加动画
        circleLayer.add(animation, forKey: "currentFlow")
    }

    private func renderEachPathOfSVGUsingCAShapeLayer3() {
        // dAttribute 类型

        // solarToDevice
        let solarToDevice = "M2 2.20605V78.9131C1.99987 79.3272 1.66413 79.6631 1.25 79.6631C0.835868 79.6631 0.50013 79.3272 0.5 78.9131"

        // 充电桩->车
        /**
         <svg xmlns="http://www.w3.org/2000/svg" width="6" height="15" viewBox="0 0 6 15" fill="none">
           <path d="M2.06812 0.00195312C2.05218 3.73317 1.72238 8.06067 5.01343 13.4434L3.70874 14.1846C0.251751 8.50266 0.540716 3.83754 0.567139 0.173828C1.02259 0.145769 1.5539 0.0963547 2.06812 0.00195312Z" fill="#535762"/>
         </svg>
         
         <svg xmlns="http://www.w3.org/2000/svg" width="6" height="15" viewBox="0 0 6 15" fill="none">
           <path d="M2.06812 0.00195312C2.05218 3.73317 1.72238 8.06067 5.01343 13.4434" stroke="#535762" stroke-width="1" fill="none"/>
         </svg>
         */
        // let chargerToVerical = "M2.06819 0.501953C2.05226 4.23317 1.72245 8.56067 5.01351 13.9434L3.70882 14.6846C0.251823 9.00265 0.541772 4.33754 0.568194 0.673828C1.02343 0.645755 1.55435 0.596288 2.06819 0.501953"
        let chargerToVerical = "M2.06812 0.00195312C2.05218 3.73317 1.72238 8.06067 5.01343 13.4434"

        let deviceToBattery = "M1.25 0.0546875C1.66413 0.0546875 1.99987 0.390586 2 0.804688V23.4736"

        let svgView = SVGPathView()
        svgView.backgroundColor = UIColor.clear
        svgView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(svgView)

        NSLayoutConstraint.activate([
            svgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            svgView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            svgView.widthAnchor.constraint(equalToConstant: 6),
            svgView.heightAnchor.constraint(equalToConstant: 15)
        ])

        svgView.setupSVGPath(svgFileName: "flow_pv_inv", strokeColor: UIColor(hex: "#535762"), lineWidth: 2)
        svgView.animateCurrent(
            duration: 2.0, particleColor: UIColor(hex: "#5CF083"), particleSize: 2, particleCount: 50)
    }
}


/**
 <svg xmlns="http://www.w3.org/2000/svg" width="6" height="15" viewBox="0 0 6 15" fill="none">
   <path d="M2.06819 0.501953C2.05226 4.23317 1.72245 8.56067 5.01351 13.9434L3.70882 14.6846C0.251823 9.00265 0.541772 4.33754 0.568194 0.673828C1.02343 0.645755 1.55435 0.596288 2.06819 0.501953Z" fill="#545C63"/>
 </svg>
 */
