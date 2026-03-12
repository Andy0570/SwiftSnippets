//
//  HeaderHeadline2.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import UIKit

typealias HeaderHeadline2Configurator = MagazineSupplementaryCellConfigurator<HeaderHeadline2VM, HeaderHeadline2>

final class HeaderHeadline2: UICollectionReusableView, ConfigurableCell {
    private let textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textColor = UIColor.mainText
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: HeaderHeadline2VM) {
        textLabel.text = item.title
    }
}
