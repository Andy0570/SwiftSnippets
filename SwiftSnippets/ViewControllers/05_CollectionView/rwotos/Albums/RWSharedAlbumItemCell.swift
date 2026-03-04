//
//  RWSharedAlbumItemCell.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/4.
//

import UIKit

enum Owner: Int, CaseIterable {
    case Tom
    case Matt
    case Ray

    func avatar() -> UIImage {
        switch self {
        case .Tom:
            return UIImage(named: "tom_profile")!
        case .Matt:
            return UIImage(named: "matt_profile")!
        case .Ray:
            return UIImage(named: "ray_profile")!
        }
    }

    func name() -> String {
        switch self {
        case .Tom: return "Tom Elliott"
        case .Matt: return "Matt Galloway"
        case .Ray: return "Ray Wenderlich"
        }
    }
}

class RWSharedAlbumItemCell: UICollectionViewCell {
    static let reuseIdentifer = "rwotos-shared-album-item-cell-reuse-identifier"
    let titleLabel = UILabel()
    let ownerLabel = UILabel()
    let featuredPhotoView = UIImageView()
    let ownerAvatar = UIImageView()
    let contentContainer = UIView()

    let owner: Owner

    var title: String? {
        didSet {
            configure()
        }
    }

    var featuredPhotoURL: URL? {
        didSet {
            configure()
        }
    }

    override init(frame: CGRect) {
        owner = Owner.allCases.randomElement()!
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RWSharedAlbumItemCell {
    private func configure() {
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentContainer)

        featuredPhotoView.translatesAutoresizingMaskIntoConstraints = false
        if let featuredPhotoURL = featuredPhotoURL {
            featuredPhotoView.image = UIImage(contentsOfFile: featuredPhotoURL.path)
        }
        featuredPhotoView.layer.cornerRadius = 4
        featuredPhotoView.clipsToBounds = true
        contentContainer.addSubview(featuredPhotoView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        titleLabel.adjustsFontForContentSizeCategory = true
        contentContainer.addSubview(titleLabel)

        ownerLabel.translatesAutoresizingMaskIntoConstraints = false
        ownerLabel.text = "From \(owner.name())"
        ownerLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        ownerLabel.adjustsFontForContentSizeCategory = true
        ownerLabel.textColor = .placeholderText
        contentContainer.addSubview(ownerLabel)

        ownerAvatar.translatesAutoresizingMaskIntoConstraints = false
        ownerAvatar.image = owner.avatar()
        ownerAvatar.layer.cornerRadius = 15
        ownerAvatar.layer.borderColor = UIColor.systemBackground.cgColor
        ownerAvatar.layer.borderWidth = 1
        ownerAvatar.clipsToBounds = true
        contentContainer.addSubview(ownerAvatar)

        let spacing = CGFloat(10)
        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            featuredPhotoView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            featuredPhotoView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            featuredPhotoView.topAnchor.constraint(equalTo: contentContainer.topAnchor),

            titleLabel.topAnchor.constraint(equalTo: featuredPhotoView.bottomAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: featuredPhotoView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: featuredPhotoView.trailingAnchor),

            ownerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            ownerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ownerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ownerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            ownerAvatar.heightAnchor.constraint(equalToConstant: 30),
            ownerAvatar.widthAnchor.constraint(equalToConstant: 30),
            ownerAvatar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
            ownerAvatar.bottomAnchor.constraint(equalTo: featuredPhotoView.bottomAnchor, constant: -spacing),
        ])
    }
}
