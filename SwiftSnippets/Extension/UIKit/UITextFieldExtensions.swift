//
//  UITextFieldExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/10.
//

import UIKit

extension UITextField {
    /// Add bottom border in textField
    ///
    /// - Parameter borderColor: bottom border color
    func addBottomBorder(borderColor: UIColor) {
        borderStyle = .none
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = false
        layer.shadowColor = borderColor.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
    }
}
