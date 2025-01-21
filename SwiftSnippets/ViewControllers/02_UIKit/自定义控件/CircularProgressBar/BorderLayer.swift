//
//  BorderLayer.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/21.
//

import UIKit

class BorderLayer: CALayer {
    var lineColor: CGColor = UIColor.blue.cgColor
    var lineWidth: CGFloat = 2.0
    var startAngle: CGFloat = 0.0
    // 在 Swift 中, @NSManaged 告诉编译器这实际上是一个 Objective-C 中的 @dynamic 变量。
    // 本质上, @dynamic 告诉 Core Animation 跟踪属性变化，然后调用 layer 中的不同方法
    @NSManaged var endAngle: CGFloat

    // CALayer 是惰性的，他们不喜欢重绘自己。这是一种内置的优化策略，可以避免在 layer 的属性没有更改的情况下意外重绘图层。
    // 当 progressBorderLayer.endAngle 属性更新时调用重绘
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "endAngle" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }

    override func draw(in ctx: CGContext) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        ctx.beginPath()
        ctx.setStrokeColor(lineColor)
        ctx.setLineWidth(lineWidth)
        ctx.addArc(
            center: center,
            radius: bounds.height / 2 - lineWidth,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        ctx.drawPath(using: .stroke)
    }
}
