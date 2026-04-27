//
//  BaseStylizedCollectionViewCell.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/27.
//

import UIKit
import SnapKit

/// SeeAlso: <https://www.advancedswift.com/uicollectionviewcell-rounded-corners-and-shadow-swift/>
final class BaseStylizedCollectionViewCell: UICollectionViewCell {
    private var imageView: UIImageView!
    private var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder) isn not available")
    }

    private func setupView() {
        contentView.backgroundColor = UIColor.white

        // Apply rounded corners
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true

        // Set masks to bounds to false to avoid the shadow
        // from being clipped to the corner radius
        layer.cornerRadius = 5.0
        layer.masksToBounds = false

        // Apply a shadow
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)

        // imageView
        imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }

        // titleLabel
        titleLabel = UILabel(frame: .zero)
        titleLabel.font = .systemFont(ofSize: 17.0, weight: .regular)
        titleLabel.textColor = UIColor.label
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.equalTo(contentView).offset(6)
            make.trailing.equalTo(contentView).offset(-6)
            make.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // 显式设置 layer.shadowPath 属性，可以提高阴影滚动性能
        // Improve scrolling performance with an explicit shadowPath
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 5.0
        ).cgPath
    }

    func configure(with title: String, imageName: String) {
        imageView.image = UIImage(named: imageName)
        titleLabel.text = title
    }
}
