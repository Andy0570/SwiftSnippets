//
//  UITextViewExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/10.
//

import UIKit

extension UITextView {
    /// Adjust height based on content and fixed width
    func layoutDynamicHeight(width: CGFloat) {
        // Requerid for dynamic height.
        if isScrollEnabled { isScrollEnabled = false }

        frame.setWidth(width)
        sizeToFit()
        if frame.width != width {
            frame.setWidth(width)
        }
    }

    /// Adjust height based on content and fixed width
    func layoutDynamicHeight(x: CGFloat, y: CGFloat, width: CGFloat) {
        // Requerid for dynamic height.
        if isScrollEnabled { isScrollEnabled = false }

        frame = CGRect(x: x, y: y, width: width, height: frame.height)
        sizeToFit()
        if frame.width != width {
            frame.setWidth(width)
        }
    }
}
