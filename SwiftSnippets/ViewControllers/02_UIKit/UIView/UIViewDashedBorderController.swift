//
//  UIViewDashedBorderController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/27.
//

import UIKit

final class UIViewDashedBorderController: UIViewController {
    // MARK: - Controls
    // 方法一，通过 Extension 扩展方法添加虚线边框
    private var customDashedBorderView: UIView!
    // 方法二，在自定义子视图中绘制虚线边框
    private var customDashedBorderView2: RectangularDashedView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}

// MARK: - Private
extension UIViewDashedBorderController {
    private func setupView() {
        view.backgroundColor = UIColor(hex: "#141414")

        // customDashedBorderView
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100) // 初始化必须设置 frame！
        customDashedBorderView = UIView(frame: frame)
        customDashedBorderView.translatesAutoresizingMaskIntoConstraints = false
        customDashedBorderView.backgroundColor = UIColor(hex: 0x828691, transparency: 0.09)
        customDashedBorderView.layer.cornerRadius = 10.0
        customDashedBorderView.layer.masksToBounds = true
        view.addSubview(customDashedBorderView)

        // customDashedBorderView2
        customDashedBorderView2 = RectangularDashedView(frame: .zero)
        customDashedBorderView2.translatesAutoresizingMaskIntoConstraints = false
        customDashedBorderView2.backgroundColor = UIColor(hex: 0x828691, transparency: 0.09)
        let borderColor = UIColor(hex: 0x878D96, transparency: 0.32).require()
        customDashedBorderView2.cornerRadius = 10.0
        customDashedBorderView2.dashColor = borderColor
        customDashedBorderView2.dashWidth = 1.0
        customDashedBorderView2.dashLength = 6.0
        customDashedBorderView2.betweenDashesSpace = 3.0
        view.addSubview(customDashedBorderView2)

        NSLayoutConstraint.activate([
            customDashedBorderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            customDashedBorderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            customDashedBorderView.widthAnchor.constraint(equalToConstant: 100),
            customDashedBorderView.heightAnchor.constraint(equalToConstant: 100),

            customDashedBorderView2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            customDashedBorderView2.leadingAnchor.constraint(equalTo: customDashedBorderView.trailingAnchor, constant: 16),
            customDashedBorderView2.widthAnchor.constraint(equalToConstant: 100),
            customDashedBorderView2.heightAnchor.constraint(equalToConstant: 100)
        ])

        // 添加边框样式,虚线效果

        customDashedBorderView.applyDashedBorder(color: borderColor, width: 1.0, cornerRadius: 10.0)
    }
}
