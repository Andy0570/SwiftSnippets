//
//  RowHeadline1.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import UIKit
import MagazineLayout

typealias RowHeadline1Configurator = MagazineCellConfigurator<RowHeadline1VM, RowHeadline1>

final class RowHeadline1: MagazineLayoutCollectionViewCell, ConfigurableCell {
    private let textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 32, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .mainText
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: RowHeadline1VM) {
        textLabel.text = item.title
    }
}
