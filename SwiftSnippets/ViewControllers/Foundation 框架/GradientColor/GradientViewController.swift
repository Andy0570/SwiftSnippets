//
//  GradientViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/3.
//

import UIKit
import SwifterSwift

/**
 使用 CAGradientLayer 创建渐变色

 这里使用了 SwifterSwift 框架中的扩展方法创建渐变图层，并应用于 UIView。

 参考：
 <https://www.swiftdevcenter.com/how-to-create-gradient-color-using-cagradientlayer/>
 */
class GradientViewController: UIViewController {
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var fiveView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let colors: [UIColor] = [.red, .blue]
        firstView.addGradient(colors: colors, direction: .topToBottom)
        secondView.addGradient(colors: colors, direction: .bottomToTop)
        thirdView.addGradient(colors: colors, direction: .leftToRight)
        thirdView.addGradient(colors: colors, direction: .rightToLeft)

        // 从左上到右下
        fourthView.addGradient(colors: colors, direction: UIView.GradientDirection(startPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 1.0, y: 1.0)))

        // 从左下到右上
        fiveView.addGradient(colors: colors, direction: UIView.GradientDirection(startPoint: CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint(x: 1.0, y: 0.0)))
    }
}
