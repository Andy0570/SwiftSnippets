//
//  AnnotatedPhotoCell.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/14.
//

import UIKit

final class AnnotatedPhotoCell: UICollectionViewCell {
    private var containerView: UIView!
    private var imageView: UIImageView!
    private var captionLabel: UILabel!
    private var commentLabel: UILabel!

    var photo: Photo? {
        didSet {
            if let photo {
                imageView.image = photo.image
                captionLabel.text = photo.caption
                commentLabel.text = photo.comment
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        captionLabel.text = nil
        commentLabel.text = nil
    }

    // 使用代码方式构建 cell 时，在这里进行自定义
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()

        isSelected = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        // containerView
        containerView = UIView(frame: .zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(hex: "0C5C2A")
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
        contentView.addSubview(containerView)

        // imageView
        imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        containerView.addSubview(imageView)

        // captionLabel
        captionLabel = UILabel(frame: .zero)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.textColor = UIColor.white
        captionLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        containerView.addSubview(captionLabel)

        // commentLabel
        commentLabel = UILabel(frame: .zero)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.textColor = UIColor.white
        commentLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        commentLabel.numberOfLines = 0
        containerView.addSubview(commentLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // 垂直方向上，降低图片的内容抗压缩优先级（Content Compression Resistance Priority），压缩图片的高度
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: captionLabel.topAnchor, constant: -10),

            captionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            captionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),

            commentLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 2),
            commentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            commentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            commentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
}
