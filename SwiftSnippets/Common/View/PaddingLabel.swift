//
//  PaddingLabel.swift
//  SeaTao
//
//  Created by Qilin Hu on 2022/7/8.
//

import UIKit

/// 给 UILabel 添加内边距
///
/// Reference: <https://stackoverflow.com/questions/27459746/adding-space-padding-to-a-uilabel>
final class PaddingLabel: UILabel {
    var contentInsets: UIEdgeInsets = .zero

    required init(withContentInsets contentInsets: UIEdgeInsets) {
        self.contentInsets = contentInsets
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }

    override var intrinsicContentSize: CGSize {
        return addInsets(to: super.intrinsicContentSize)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return addInsets(to: super.sizeThatFits(size))
    }

    private func addInsets(to size: CGSize) -> CGSize {
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }
}
