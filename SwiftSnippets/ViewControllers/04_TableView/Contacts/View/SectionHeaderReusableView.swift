//
//  SectionHeaderReusableView.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/4.
//

import UIKit

class SectionHeaderReusableView: UITableViewHeaderFooterView {
    static var reuseIdentifier: String {
        return String(describing: SectionHeaderReusableView.self)
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(titleLabel)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
    }
}
