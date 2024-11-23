//
//  UIImageExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/8.
//

import UIKit

extension UIImage {
    /// 调整 UIImage 尺寸
    ///
    /// - SeeAlso: <https://stackoverflow.com/questions/2658738/the-simplest-way-to-resize-an-uiimage>
    func resize(to size: CGSize, retina: Bool = true) -> UIImage? {
         // In next line, pass 0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
         // Pass 1 to force exact pixel size.
         UIGraphicsBeginImageContextWithOptions(
             /* size: */ size,
             /* opaque: */ false,
             /* scale: */ retina ? 0 : 1
         )
         defer { UIGraphicsEndImageContext() }

         self.draw(in: CGRect(origin: .zero, size: size))
         return UIGraphicsGetImageFromCurrentImageContext()
     }

    /// 生成 1x1 大小的纯色图片
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    /// 生成从左到右的渐变图片
    static func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        // 从左到右渐变，默认是从上到下，即 (0.5, 0.0) -> (0.5, 1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            gradientLayer.render(in: context.cgContext)
        }
    }
}
