//
//  BaseTableViewCell.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/2/6.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()

        // MARK: 在根视图层上设置阴影
        applyShadow(cornerRadius: 8)
    }
}

extension UIView {
    func applyShadow(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.30
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}
