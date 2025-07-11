//
//  ChecklistItemTableViewCell.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/22.
//

import UIKit

class ChecklistItemTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityTraits = .button
        label.accessibilityHint = "Double tap to open"
        label.isAccessibilityElement = true
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        return label
    }()

    private lazy var completionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit

        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "square", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.systemBlue
        button.isUserInteractionEnabled = true
        button.isAccessibilityElement = true
        button.accessibilityTraits = .button
        button.accessibilityLabel = "Mark as Complete"
        return button
    }()

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()

    var item: ChecklistItem? {
        didSet {
            guard let item else {
                return
            }

            let subtitleText = dateFormatter.string(from: item.date)

            titleLabel.text = item.title
            subtitleLabel.text = subtitleText

            // The title acts as the cell to voice over because marking the cell as the accessibility element would prevent the checkmark box from being discovered by VoiceOver and other accessibility technologies
            titleLabel.accessibilityLabel = "\(item.title)\n\(subtitleText)"

            updateCompletionStatusAccessibilityInformation()
        }
    }

    static let reuseIdentifier = String(describing: ChecklistItemTableViewCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(completionButton)

        completionButton.addTarget(self, action: #selector(userDidTapOnCheckmarkBox), for: .touchUpInside)

        layoutSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if traitCollection.horizontalSizeClass == .compact {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 4),
                completionButton.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -4)
            ])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                completionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ])
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: completionButton.leadingAnchor, constant: -5),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            completionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            completionButton.widthAnchor.constraint(equalToConstant: 30),
            completionButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc func userDidTapOnCheckmarkBox() {
        guard let item else {
            return
        }

        item.completed.toggle()

        updateCompletionStatusAccessibilityInformation()

        UIView.transition(with: completionButton, duration: 0.2, options: .transitionCrossDissolve) {
            let symbolName: String

            if item.completed {
                symbolName = "Checkmark.square"
            } else {
                symbolName = "square"
            }

            let configuration = UIImage.SymbolConfiguration(scale: .large)
            let image = UIImage(systemName: symbolName, withConfiguration: configuration)
            self.completionButton.setImage(image, for: .normal)
        }
    }

    private func updateCompletionStatusAccessibilityInformation() {
        if item?.completed == true {
            completionButton.accessibilityLabel = "Mark as incomplete"
        } else {
            completionButton.accessibilityLabel = "Mark as complete"
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        layoutSubviews()
    }
}
