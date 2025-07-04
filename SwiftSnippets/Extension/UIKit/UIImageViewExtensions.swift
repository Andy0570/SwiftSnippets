//
//  UIImageViewExtensions.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/4.
//

import UIKit

extension UIImageView {
    /// Sets the image property of the view based on initial text, a specified background color, custom text attributes, and a circular clipping
    ///
    /// - Parameters:
    ///   - string: The string used to generate the initials. This should be a user's full name if available.
    ///   - color: This optional paramter sets the background of the image. By default, a random color will be generated.
    ///   - circular: This boolean will determine if the image view will be clipped to a circular shape.
    ///   - textAttributes: This dictionary allows you to specify font, text color, shadow properties, etc.
    public func setImage(string: String,
                         color: UIColor? = nil,
                         circular: Bool = false,
                         textAttributes: [NSAttributedString.Key: Any]? = nil) {
        let image = imageSnap(text: string,
                              color: color ?? .randomColor(),
                              circular: circular,
                              textAttributes: textAttributes)

        if let newImage = image {
            self.image = newImage
        }
    }

    private func imageSnap(text: String?,
                           color: UIColor,
                           circular: Bool,
                           textAttributes: [NSAttributedString.Key: Any]?) -> UIImage? {
        let scale = Float(UIScreen.main.scale)
        var size = bounds.size
        size.width = CGFloat(floorf((Float(size.width) * scale) / scale))
        size.height = CGFloat(floorf((Float(size.height) * scale) / scale))

        UIGraphicsBeginImageContextWithOptions(size, false, CGFloat(scale))
        let context = UIGraphicsGetCurrentContext()
        if circular {
            let path = CGPath(ellipseIn: bounds, transform: nil)
            context?.addPath(path)
            context?.clip()
        }

        context?.setFillColor(color.cgColor)
        context?.fill( CGRect(x: 0, y: 0, width: size.width, height: size.height) )

        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setLineWidth(8)
        context?.strokeEllipse(in: bounds)

        if let text = text {
            let attributes = textAttributes ?? [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold) ]

            let textSize = text.size(withAttributes: attributes)
            let bounds = self.bounds
            let rect = CGRect(x: bounds.size.width / 2 - textSize.width / 2, y: bounds.size.height / 2 - textSize.height / 2, width: textSize.width, height: textSize.height)

            text.draw(in: rect, withAttributes: attributes)
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
