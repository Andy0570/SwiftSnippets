//
//  CornerRadiusTableViewCell.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/2/6.
//

import UIKit

class CornerRadiusTableViewCell: BaseTableViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // MARK: 在自定义容器视图层上设置圆角
        backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.systemBackground
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
    }
}
