//
//  CardPhotoThumbnail.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import UIKit
import MagazineLayout
import Kingfisher

typealias CardPhotoThumbnailConfigurator = MagazineCellConfigurator<CardPhotoThumbnailVM, CardPhotoThumbnail>

final class CardPhotoThumbnail: UICollectionViewCell, ConfigurableCell {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.backgroundColor = .placeholder
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: CardPhotoThumbnailVM) {
        imageView.kf.setImage(
            with: URL(string: item.url),
            options: [.transition(.fade(0.3))]
        )
    }
}
