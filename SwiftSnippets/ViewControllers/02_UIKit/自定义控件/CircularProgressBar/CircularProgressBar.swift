//
//  CircularProgressBar.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/21.
//

import UIKit

/// 使用 .xib 文件创建自定义视图
/// 参考
/// * <https://www.scalablepath.com/ios/ios-custom-views-uikit>
/// * <https://nshipster.com/ibinspectable-ibdesignable/>
/// * <https://manasaprema04.medium.com/different-way-of-creating-uiviews-in-swift-4aeb1b5d0d6b>
@IBDesignable
open class CircularProgressBar: UIView {
    var view: UIView!

    static let startAngle = 3 / 2 * CGFloat.pi
    static let endAngle = 7 / 2 * CGFloat.pi

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    let darkBorderLayer = BorderLayer()
    var progressBorderLayer = BorderLayer()

    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    @IBInspectable var subtitle: String = "" {
        didSet {
            subtitleLabel.text = subtitle
        }
    }

    @IBInspectable var progress: CGFloat = 0.0 {
        didSet {
            // 根据输入的进度值更新 ProgressBorderLayer 的 endAngle 属性
            progressBorderLayer.endAngle = CircularProgressBar.radianForValue(progress)
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
        commonInit()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        darkBorderLayer.frame = self.bounds
        progressBorderLayer.frame = self.bounds

        // 调用 setNeedsDisplay() 方法通知系统，图层内容需要重绘
        darkBorderLayer.setNeedsDisplay()
        progressBorderLayer.setNeedsDisplay()
    }

    private func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Unable to load view from nib.")
        }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        self.view = view
    }

    open func commonInit() {
        darkBorderLayer.lineColor = UIColor(red: 134 / 255, green: 133 / 255, blue: 148 / 255, alpha: 1).cgColor
        darkBorderLayer.startAngle = CircularProgressBar.startAngle
        darkBorderLayer.endAngle = CircularProgressBar.endAngle
        self.layer.addSublayer(darkBorderLayer)

        progressBorderLayer.lineColor = UIColor(red: 168 / 255, green: 207 / 255, blue: 45 / 255, alpha: 1).cgColor
        progressBorderLayer.startAngle = CircularProgressBar.startAngle
        progressBorderLayer.endAngle = CircularProgressBar.endAngle
        self.layer.addSublayer(progressBorderLayer)
    }

    // 将数值转换为等效的弧度值
    internal class func radianForValue(_ value: CGFloat) -> CGFloat {
        let realValue = CircularProgressBar.sanitizeValue(value)
        return (realValue * 2.0 * CGFloat.pi / 100) + CircularProgressBar.startAngle
    }

    internal class func sanitizeValue(_ value: CGFloat) -> CGFloat {
        var realValue = value
        if value < 0 {
            realValue = 0
        } else if value > 100 {
            realValue = 100
        }
        return realValue
    }
}
