//
//  RWPhotoItemCell.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/4.
//

import UIKit

class RWPhotoItemCell: UICollectionViewCell {
    static let reuseIdentifer = "rwotos-photo-item-cell-reuse-identifier"
    let imageView = UIImageView()
    let contentContainer = UIView()
    
    var photoURL: URL? {
        didSet {
            configure()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RWPhotoItemCell {
    private func configure() {
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentContainer)

        guard let photoURL = self.photoURL else { return };
        let photo = UIImage(contentsOfFile: photoURL.path)
        imageView.image = photo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(imageView)

        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: contentContainer.topAnchor)
        ])
    }
}
