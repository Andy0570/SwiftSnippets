//
//  AnimatorTrigger.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/11/22.
//

import UIKit
import ViewAnimator

/// 转场动画效果，对 ViewAnimator 的封装
///
/// - SeeAlso: <https://github.com/marcosgriselli/ViewAnimator>
enum AnimatorTrigger {
    static let animationInterval: TimeInterval = 0.2
    static let duration: TimeInterval = 0.3

    // Float Animation
    enum FloatDirection {
        case toTop
        case toRight
        case toBottom
        case toLeft
    }

    static func float(
        views: [UIView],
        direction: FloatDirection = .toTop,
        delay: Double = 0.1,
        animationInterval: TimeInterval = animationInterval,
        duration: TimeInterval = duration
    ) {
        let volumn: CGFloat = 50.0

        var vector: CGVector
        switch direction {
        case .toTop:
            vector = CGVector(dx: 0, dy: volumn)
        case .toRight:
            vector = CGVector(dx: -volumn, dy: 0)
        case .toBottom:
            vector = CGVector(dx: 0, dy: -volumn)
        case .toLeft:
            vector = CGVector(dx: volumn, dy: 0)
        }

        let animation = AnimationType.vector(vector)

        UIView.animate(
            views: views,
            animations: [animation],
            delay: delay,
            animationInterval: animationInterval,
            duration: duration
        )
    }
}
