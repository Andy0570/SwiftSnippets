//
//  CardDestination.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import UIKit
import MagazineLayout
import Kingfisher

typealias CardDestinationConfigurator = MagazineCellConfigurator<CardDestinationVM, CardDestination>

final class CardDestination: UICollectionViewCell, ConfigurableCell {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.backgroundColor = .placeholder
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.subtitleLabel.snp.top)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: CardDestinationVM) {
        imageView.kf.setImage(
            with: URL(string: item.imageUrl),
            options: [.transition(.fade(0.3))]
        )
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
}
