//
//  TextSize.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/18.
//

import UIKit

/// 计算一段文字在指定字体和指定宽度下所占用的矩形大小（CGRect），并缓存计算结果。
public struct TextSize {
    private final class CacheKey: NSObject {
        let text: String
        let font: UIFont
        let width: CGFloat
        let insets: UIEdgeInsets
        
        init(text: String, font: UIFont, width: CGFloat, insets: UIEdgeInsets) {
            self.text = text
            self.font = font
            self.width = width
            self.insets = insets
        }
        
        override var hash: Int {
            var hasher = Hasher()
            hasher.combine(text)
            hasher.combine(font.hashValue)
            hasher.combine(width)
            hasher.combine(insets.top)
            hasher.combine(insets.left)
            hasher.combine(insets.bottom)
            hasher.combine(insets.right)
            return hasher.finalize()
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let other = object as? CacheKey else { return false }
            return text == other.text &&
                   font == other.font &&
                   width == other.width &&
                   insets == other.insets
        }
    }
    
    private static let cache = NSCache<CacheKey, NSValue>()
    
    // MARK: - 主方法
    public static func size(text: String, font: UIFont, width: CGFloat, insets: UIEdgeInsets = .zero) -> CGRect {
        let key = CacheKey(text: text, font: font, width: width, insets: insets)
        
        // 查缓存
        if let cachedValue = cache.object(forKey: key) {
            return cachedValue.cgRectValue
        }
        
        // 没有缓存则计算
        let constrainedSize = CGSize(width: width - insets.left - insets.right, height: .greatestFiniteMagnitude)
        let attributes = [NSAttributedString.Key.font: font]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        var bounds = (text as NSString).boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        bounds.size.width = width
        bounds.size.height = ceil(bounds.height + insets.top + insets.bottom)
        
        // 存缓存
        cache.setObject(NSValue(cgRect: bounds), forKey: key)
        
        return bounds
    }
}
