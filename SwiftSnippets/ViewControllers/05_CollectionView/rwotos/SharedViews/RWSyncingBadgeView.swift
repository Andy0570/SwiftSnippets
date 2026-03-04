//
//  RWSyncingBadgeView.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/4.
//

import UIKit

class RWSyncingBadgeView: UICollectionReusableView {
    static let reuseIdentifier = "rwotos-syncing-badge"
    let imageView = UIImageView(image: UIImage(named: "syncIcon"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        startAnimating()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RWSyncingBadgeView {
    private func configure() {
        backgroundColor = .white
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        let inset = CGFloat(2)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        
        let radius = bounds.width / 2.0
        layer.cornerRadius = radius
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }
    
    private func startAnimating() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        imageView.layer.add(rotation, forKey: "rotationAnimation")
    }
}
