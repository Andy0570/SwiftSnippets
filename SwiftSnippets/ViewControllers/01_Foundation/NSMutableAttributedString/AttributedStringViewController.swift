//
//  AttributedStringViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/2.
//

import UIKit

/**
 ### NSAttributedString

 使用 NSMutableAttributedString 和 NSAttributedString 实现多种字体、颜色、下划线、删除线、阴影等等。
 参考：<https://www.swiftdevcenter.com/nsmutableattributedstring-tutorial-by-example/>

 ### AttributedString

 使用 iOS 15 的 AttributedString 特性创建样式化文本。
 参考：<https://fatbobman.com/zh/posts/attributedstring/>
 */
class AttributedStringViewController: UIViewController {
    let appRedColor = UIColor(red: 230.0 / 255.0, green: 51.0 / 255.0, blue: 49.0 / 255.0, alpha: 1.0)
    let appBlueColor = UIColor(red: 62.0 / 255.0, green: 62.0 / 255.0, blue: 145.0 / 255.0, alpha: 1.0)
    let appYellowColor = UIColor(red: 248.0 / 255.0, green: 175.0 / 255.0, blue: 0.0, alpha: 1.0)
    let darkOrangeColor = UIColor(red: 248.0 / 255.0, green: 150.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)

    @IBOutlet private var firstLabel: UILabel!
    @IBOutlet private var secondLabel: UILabel!
    @IBOutlet private var thirdLabel: UILabel!
    @IBOutlet private var fourthLabel: UILabel!
    @IBOutlet private var fifthLabel: UILabel!
    @IBOutlet private var sixLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        // 基于 Objective-C 的 NSAttributedString 来创建样式化文本
        setFirstLabel()
        setSecondLabel()
        setThirdLabel()
        setFourthLabel()
        setFifthLabel()

        // 基于 Swift 的 AttributedString 创建样式化文本
        setSixLabel()
    }

    // 颜色
    private func setFirstLabel() {
        let text = "This is a colorful attributed string"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(color: appRedColor, subString: "This")
        // Range of substring "is a"
        attributedText.apply(color: appYellowColor, onRange: NSRange(location: 5, length: 4))
        attributedText.apply(color: .purple, subString: "colorful")
        attributedText.apply(color: appBlueColor, subString: "attributed")
        attributedText.apply(color: darkOrangeColor, subString: "string")
        firstLabel.attributedText = attributedText
    }

    // 字体
    private func setSecondLabel() {
        guard let boldItalicFont = UIFont(name: "HelveticaNeue-BoldItalic", size: 20),
              let thinItalicFont = UIFont(name: "HelveticaNeue-ThinItalic", size: 20),
              let condensedBlackFont = UIFont(name: "HelveticaNeue-CondensedBlack", size: 20) else {
            return
        }

        let text = "This string is having multiple font"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(font: UIFont.boldSystemFont(ofSize: 24), subString: "This")
        attributedText.apply(font: UIFont.boldSystemFont(ofSize: 24), onRange: NSRange(location: 5, length: 6))
        attributedText.apply(font: UIFont.italicSystemFont(ofSize: 20), subString: "string")
        attributedText.apply(font: boldItalicFont, subString: " is")
        attributedText.apply(font: thinItalicFont, subString: "having")
        attributedText.apply(color: .blue, subString: "having")
        attributedText.apply(font: condensedBlackFont, subString: "multiple")
        attributedText.apply(color: appRedColor, subString: "multiple")
        secondLabel.attributedText = attributedText
    }

    // 下划线、背景色
    private func setThirdLabel() {
        let text = "This is underline string"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.underLine(subString: "This is underline string")
        attributedText.apply(backgroundColor: appYellowColor, subString: "underline")
        thirdLabel.attributedText = attributedText
    }

    // 删除线、下划线、描边
    private func setFourthLabel() {
        let text = "This is a strike and underline stroke string"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.strikeThrough(thickness: 2, subString: "This is a")
        attributedText.underLine(subString: "underline")
        attributedText.applyStroke(color: appRedColor, thickness: 2, subString: "stroke string")
        fourthLabel.attributedText = attributedText
    }

    // 阴影
    private func setFifthLabel() {
        let text = "This string is having a shadow"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.applyShadow(shadowColor: .black, shadowWidth: 4.0, shadowHeight: 4.0, shadowRadius: 4.0, subString: "This string is")
        attributedText.applyShadow(shadowColor: .black, shadowWidth: 0, shadowHeight: 0, shadowRadius: 5.0, subString: "having")
        attributedText.applyShadow(shadowColor: .black, shadowWidth: 4.0, shadowHeight: 4.0, shadowRadius: 4.0, subString: "a shadow")
        fifthLabel.attributedText = attributedText
    }

    // 生成一个包含粗体以及超链接的属性字符串
    private func setSixLabel() {
        var attributedString = AttributedString("使用 AttributedString 创建属性字符串")
        let boldStringRange = attributedString.range(of: "AttributedString").require() // 获取指定字符串范围（Range）
        attributedString[boldStringRange].inlinePresentationIntent = .stronglyEmphasized // 设置粗体属性
        let linkStringRange = attributedString.range(of: "属性字符串").require()
        attributedString[linkStringRange].link = URL(string: "https://www.baidu.com").require() // 设置超链接属性

        // AttributedString -> NSAttributedString
        sixLabel.attributedText = NSAttributedString(attributedString)
    }
}
