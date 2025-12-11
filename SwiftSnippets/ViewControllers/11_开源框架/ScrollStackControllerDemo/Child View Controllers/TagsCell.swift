//
//  TagsCell.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/11.
//

import UIKit

class TagsCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    public var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = UIColor.purple

        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }
}
