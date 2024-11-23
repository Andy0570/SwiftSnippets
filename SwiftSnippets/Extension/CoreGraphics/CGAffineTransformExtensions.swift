//
//  CGAffineTransformExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/10.
//

import CoreGraphics

// MARK: - Initializers

extension CGAffineTransform {
    /// Create 'CGAffineTransform' instance with scale value.
    /// - Parameter scale: scale value.
    init(scale: CGFloat) {
        self.init(scaleX: scale, y: scale)
    }
}
