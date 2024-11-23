//
//  CGRectExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/10.
//

import CoreGraphics

// MARK: - Initializers

extension CGRect {
    /// Create a `CGRect` instance with x, maxY, width and height.
    init(x: CGFloat, maxY: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(x: x, y: maxY - height, width: width, height: height)
    }

    /// Create a `CGRect` instance with maxX, y, width and height.
    init(maxX: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(x: maxX - width, y: y, width: width, height: height)
    }

    /// Create a `CGRect` instance with maxX, maxY, width and height.
    init(maxX: CGFloat, maxY: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(x: maxX - width, y: maxY - height, width: width, height: height)
    }

    /// Create a Square with side value
    init(x: CGFloat, y: CGFloat, side: CGFloat) {
        self.init(x: x, y: y, width: side, height: side)
    }

    /// Create a Square with side value
    init(side: CGFloat) {
        self.init(x: .zero, y: .zero, width: side, height: side)
    }
}

// MARK: - Methods

extension CGRect {
    /// set CGRect maxX value
    mutating func setMaxX(_ value: CGFloat) {
        origin.x = value - width
    }

    /// set CGRect maxY value
    mutating func setMaxY(_ value: CGFloat) {
        origin.y = value - height
    }

    /// set CGRect width value
    mutating func setWidth(_ width: CGFloat) {
        if width == self.width {
            return
        }

        self = CGRect(x: origin.x, y: origin.y, width: width, height: height)
    }

    /// set CGRect height value
    mutating func setHeight(_ height: CGFloat) {
        if height == self.height {
            return
        }

        self = CGRect(x: origin.x, y: origin.y, width: width, height: height)
    }
}
