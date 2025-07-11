//
//  FlickrPhotoHeaderView.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/10.
//

import UIKit

final class FlickrPhotoHeaderView: UICollectionReusableView {
    var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.opaqueSeparator

        // titleLabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 32, weight: .regular)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
