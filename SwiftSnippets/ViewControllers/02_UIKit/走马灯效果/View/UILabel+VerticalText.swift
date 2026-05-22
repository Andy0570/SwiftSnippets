//
//  UILabel+VerticalText.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/29.
//

import UIKit

extension UILabel {
    func configVerticalText(verticalText: String) {
        var tempString = verticalText
        for index in 1..<verticalText.count {
            tempString.insert("\n", at: tempString.index(tempString.startIndex, offsetBy: (index * 2 - 1)))
        }
        self.text = tempString
        self.numberOfLines = 0
    }
}
