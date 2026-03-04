//
//  RWHeaderView.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/4.
//

import UIKit

class RWHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "rwotos-header-reuse-identifier"
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RWHeaderView {
    private func configure() {
        backgroundColor = .systemBackground
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        addSubview(label)
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }
}
