//
//  UIExtendedButton.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit

/// 可扩大点击区域的按钮
final class EnlargedHitAreaButton: UIButton {
    /// 内边距（正值表示点击区域扩大，负值表示缩小）
    var hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // 扩展按钮的点击区域
        let relativeFrame = bounds
        let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
}

/**
 使用示例：
 
 // closeButton
 let closeButton = EnlargedHitAreaButton(type: .custom)
 closeButton.translatesAutoresizingMaskIntoConstraints = false
 closeButton.setImage(UIImage(named: "plant_date_cancel"), for: .normal)
 // 四周扩大 10pt
 closeButton.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
 closeButton.addTarget(self, action: #selector(closeButtonDidTapped(_:)), for: .touchUpInside)
 contentView.addSubview(closeButton)
 */
