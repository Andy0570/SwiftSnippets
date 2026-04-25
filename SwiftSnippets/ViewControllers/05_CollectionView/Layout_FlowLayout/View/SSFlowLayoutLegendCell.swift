//
//  SSFlowLayoutLegendCell.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/23.
//

import UIKit
import SnapKit

/// 把图例项渲染成一个「颜色方块 + 标题」的可复用 Cell
final class SSFlowLayoutLegendCell: UICollectionViewCell {
    // MARK: - Controls
    private var rectangleView: UIView!
    private var titleLabel: UILabel!

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Interface Builder is not supported!")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        fatalError("Interface Builder is not supported!")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let target = CGSize(width: UIView.layoutFittingExpandedSize.width, height: 26)
        let fitting = contentView.systemLayoutSizeFitting(
            target,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required
        )
        var frame = attributes.frame
        frame.size.width = ceil(fitting.width)
        frame.size.height = 26
        attributes.frame = frame
        return attributes
    }

    // MARK: - Public

    /// 与 `setupView` 约束一致：左 8 + 色块 10 + 间距 4 + 文案（≤216）+ 右 10；用于横屏图例列宽 `min(最大值, 216)`
    static func preferredFittingSize(for item: SSFlowLayoutItem) -> CGSize {
        let maxLabelWidth: CGFloat = 216
        let font = UIFont.systemFont(ofSize: 13, weight: .regular)
        let text = item.category
        let rect = text.boundingRect(
            with: CGSize(width: maxLabelWidth, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        let labelWidth = min(ceil(rect.width), maxLabelWidth)
        let horizontalChrome: CGFloat = 8 + 12 + 4 + 10
        let width = horizontalChrome + labelWidth
        let height: CGFloat = 26
        return CGSize(width: width, height: height)
    }

    func configure(with item: SSFlowLayoutItem) {
        titleLabel.text = item.category

        if item.isSelect {
            rectangleView.backgroundColor = item.chartColor
            rectangleView.layer.borderColor = item.chartColor.cgColor
        } else {
            rectangleView.backgroundColor = .clear
            rectangleView.layer.borderColor = UIColor(hex: 0x878D96, transparency: 0.83)?.cgColor
        }
    }
}

// MARK: - Private
extension SSFlowLayoutLegendCell {
    private func setupView() {
        contentView.backgroundColor = UIColor(hex: 0x1C1C1E)
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor(hex: 0x878D96, transparency: 0.32)?.cgColor
        layer.cornerRadius = 6
        layer.masksToBounds = false

        // rectangleView
        rectangleView = UIView(frame: .zero)
        rectangleView.layer.cornerRadius = 2
        rectangleView.layer.masksToBounds = true
        rectangleView.layer.borderWidth = 1.0
        rectangleView.layer.borderColor = UIColor(hex: 0x878D96, transparency: 0.83)?.cgColor
        contentView.addSubview(rectangleView)
        rectangleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 12, height: 12))
        }

        // titleLabel
        titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        titleLabel.textColor = UIColor(hex: 0xE9EBF0)
        titleLabel.textAlignment = .natural
        titleLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(rectangleView.snp.trailing).offset(4)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.trailing.equalToSuperview().offset(-10)
            make.width.lessThanOrEqualTo(216)
        }
    }
}
