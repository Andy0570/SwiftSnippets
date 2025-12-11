//
//  PricingCell.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/11.
//

import UIKit

class PricingCell: UITableViewCell {
    // MARK: - Controls
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var priceLabel: UILabel!

    var priceTag: PricingTag? {
        didSet {
            titleLabel.text = priceTag?.title ?? ""
            subtitleLabel.text = priceTag?.subtitle ?? ""
            priceLabel.text = priceTag?.price ?? ""
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        // titleLabel
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.label
        contentView.addSubview(titleLabel)

        // subtitleLabel
        subtitleLabel = UILabel(frame: .zero)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textColor = UIColor.secondaryLabel
        contentView.addSubview(subtitleLabel)

        // priceLabel
        priceLabel = UILabel(frame: .zero)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textColor = UIColor.black
        priceLabel.font = .systemFont(ofSize: 18, weight: .bold)
        contentView.addSubview(priceLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
