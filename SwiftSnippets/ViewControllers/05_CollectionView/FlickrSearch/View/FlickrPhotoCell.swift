//
//  FlickrPhotoCell.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/10.
//

import UIKit

final class FlickrPhotoCell: UICollectionViewCell {
    var imageView: UIImageView!
    var activityIndicator: UIActivityIndicatorView!

    override var isSelected: Bool {
        didSet {
            imageView.layer.borderWidth = isSelected ? 10 : 0
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
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
        // imageView
        imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)

        // activityIndicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityIndicator)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
