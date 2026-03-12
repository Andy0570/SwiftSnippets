//
//  RowText.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import UIKit
import MagazineLayout

typealias RowTextConfigurator = MagazineCellConfigurator<RowTextVM, RowText>

final class RowText: MagazineLayoutCollectionViewCell, ConfigurableCell {
    private let textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .captionText
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: RowTextVM) {
        textLabel.text = item.text
    }
}
