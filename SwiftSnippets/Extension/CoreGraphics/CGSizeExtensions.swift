//
//  CGSizeExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/10.
//

import CoreGraphics

// MARK: - Initializers

extension CGSize {
    /// initialize square size.
    /// - Parameter side: side length of a square.
    init(side: CGFloat) {
        self.init(width: side, height: side)
    }
}
