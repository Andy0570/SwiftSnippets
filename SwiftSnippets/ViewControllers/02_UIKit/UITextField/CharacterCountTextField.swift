//
//  CharacterCountTextField.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/19.
//

import UIKit

/// 带字符计数的文本输入框
/// 参考：<https://stasost.medium.com/ios-text-field-built-in-animated-character-counter-25c97110fc7e>
class CharacterCountTextField: UITextField {
    private let countLabel = UILabel()

    var countLabelTextColor = UIColor.black
    var lengthLimit: Int = 0 {
        didSet {
            setupCountLabel()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        if lengthLimit > 0 {
            return CGRect(x: frame.width - 35, y: (frame.height - 30) / 2.0, width: 30, height: 30)
        } else {
            return CGRect.zero
        }
    }

    private func setupCountLabel() {
        if lengthLimit > 0 {
            rightViewMode = .always
            countLabel.font = font?.withSize(10)
            countLabel.textColor = countLabelTextColor
            countLabel.textAlignment = .left
            rightView = countLabel

            countLabel.text = initialCounterValue(text: text)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notification:)), name: UITextField.textDidChangeNotification, object: nil)
    }

    private func initialCounterValue(text: String?) -> String {
        if let text {
            return "\(text.count)/\(lengthLimit)"
        } else {
            return "0/\(lengthLimit)"
        }
    }

    @objc func textDidChange(notification: Notification) {
        // 判断是否存在 markedText，如果存在，则不进行字数统计和字符串截断
        guard let text = self.text, lengthLimit != 0, self.markedTextRange == nil else {
            return
        }

        if text.count <= lengthLimit {
            countLabel.text = "\(text.count)/\(lengthLimit)"
        } else {
            guard let startPosition = self.selectedTextRange?.start else {
                return
            }

            // 记录当前光标的位置
            let targetPosition = self.offset(from: self.beginningOfDocument, to: startPosition)

            // 字符串截取
            let prefixIndex = text.index(text.startIndex, offsetBy: lengthLimit)
            self.text = String(text[..<prefixIndex])

            // 恢复光标位置
            if let targetPosition = self.position(from: self.beginningOfDocument, offset: targetPosition) {
                self.selectedTextRange = self.textRange(from: targetPosition, to: targetPosition)
            }

            countLabel.text = "\(lengthLimit)/\(lengthLimit)"
        }
    }
}
