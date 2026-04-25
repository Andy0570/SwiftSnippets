//
//  SSFlowLayoutLegendHeaderView.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/23.
//

import UIKit
import SnapKit

/// 图例 Header View
final class SSFlowLayoutLegendHeaderView: UICollectionReusableView {
    static let preferredHeight: CGFloat = 23

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        // label
        titleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        titleLabel.textColor = UIColor(hex: 0x666A76)
        titleLabel.textAlignment = .natural
        titleLabel.numberOfLines = 1

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(18)
            make.bottom.equalToSuperview().offset(-5)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with section: SSFlowLayoutSection) {
        titleLabel.text = section.displayTitle
    }
}
