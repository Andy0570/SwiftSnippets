//
//  TitleContentDialog.swift
//  FoxEssProject
//
//  Created by huqilin on 2025/7/28.
//

import UIKit

final class TitleContentDialog: BaseView {
    // MARK: - Public
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    var content: String? {
        didSet {
            contentLabel.text = content
        }
    }
    
    // MARK: - Controls
    private var containerView: UIView!
    private var titleLabel: UILabel!
    private var contentLabel: UILabel!
    private var closeButton: UIButton!
    
    override func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        // containerView
        containerView = UIView(frame: .zero)
        containerView.backgroundColor = ColorPalette.background
        containerView.layer.cornerRadius = 12.0
        containerView.layer.masksToBounds = true
        addConstrainedSubview(containerView)

        // titleLabel
        titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = UIColor.label
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        containerView.addConstrainedSubview(titleLabel)
        
        // contentLabel
        contentLabel = UILabel(frame: .zero)
        contentLabel.textColor = UIColor.secondaryLabel
        contentLabel.font = .systemFont(ofSize: 17, weight: .regular)
        contentLabel.numberOfLines = 0
        containerView.addConstrainedSubview(contentLabel)
        
        // closeButton
        closeButton = UIButton(type: .custom)
        let closeImage = UIImage(systemName: "xmark.circle.fill")
        closeButton.setImage(closeImage, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonDidTapped(_:)), for: .touchUpInside)
        containerView.addConstrainedSubview(closeButton)
    }
    
    override func setupLayout() {
        let padding = 16.0
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            contentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    @objc private func closeButtonDidTapped(_ sender: UIButton) {
        removeFromSuperview()
    }
}
