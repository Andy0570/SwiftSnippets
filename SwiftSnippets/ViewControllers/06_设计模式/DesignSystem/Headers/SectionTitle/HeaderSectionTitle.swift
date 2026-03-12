//
//  HeaderSectionTitle.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import UIKit

typealias HeaderSectionTitleConfigurator = MagazineSupplementaryCellConfigurator<HeaderSectionTitleVM, HeaderSectionTitle>

final class HeaderSectionTitle: UICollectionReusableView, ConfigurableCell {
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.captionText
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(8)
        }

        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: HeaderSectionTitleVM) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
}
