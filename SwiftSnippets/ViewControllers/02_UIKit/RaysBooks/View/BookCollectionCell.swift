//
//  BookCollectionCell.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/13.
//

import UIKit

/// RaysBooks 示例，集合视图 Cell
class BookCollectionCell: UICollectionViewCell {
    /// 书本封面
    private lazy var bookCoverView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .leading
        return stackView
    }()

    /// 标题
    private lazy var bookTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        return label
    }()

    /// 子标题
    private lazy var bookSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .left
        return label
    }()

    /// 添加到购物车
    private lazy var addToCartButton: UIButton = {
        var config = UIButton.Configuration.gray()
        config.image = UIImage(systemName: "cart.badge.plus")

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.tintColor = .systemBlue

        // 使用 configurationUpdateHandler 自动根据购物车状态更新按钮样式
        button.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            let symbolName = self.isBookInCart ? "cart.badge.minus" : "cart.badge.plus"
            config?.image = UIImage(systemName: symbolName)
            button.configuration = config
        }

        button.addAction(
            UIAction { _ in
                if let inCart = self.didTapCartButton?() {
                    self.isBookInCart = inCart
                }
            },
            for: .touchUpInside
        )
        return button
    }()

    /// 分割线
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()

    public var book: Book? {
        didSet {
            guard let book else {
                return
            }

            bookCoverView.image = UIImage(named: book.imageName)
            bookTitleLabel.text = book.name
            bookSubtitleLabel.text = book.edition

            addToCartButton.isEnabled = book.available
        }
    }

    public var showAddButton = true {
        didSet {
            addToCartButton.isHidden = !showAddButton
        }
    }

    public var isBookInCart = false {
        didSet {
            addToCartButton.setNeedsUpdateConfiguration()
        }
    }

    public var didTapCartButton: (() -> Bool)?

    public static var reuseIdentifier: String {
        return String(describing: self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(bookCoverView)
        contentView.addSubview(textStackView)

        textStackView.addArrangedSubview(bookTitleLabel)
        textStackView.addArrangedSubview(bookSubtitleLabel)

        contentView.addSubview(addToCartButton)
        contentView.addSubview(separatorView)

        layoutSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let imageWidthRatio: CGFloat = traitCollection.userInterfaceIdiom == .pad ? 1 / 8 : 1 / 4

        NSLayoutConstraint.activate([
            bookCoverView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            bookCoverView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            bookCoverView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            bookCoverView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: imageWidthRatio),

            textStackView.leadingAnchor.constraint(equalTo: bookCoverView.trailingAnchor, constant: 10),
            textStackView.centerYAnchor.constraint(equalTo: bookCoverView.centerYAnchor),
            textStackView.trailingAnchor.constraint(equalTo: addToCartButton.leadingAnchor, constant: -10),

            addToCartButton.centerYAnchor.constraint(equalTo: textStackView.centerYAnchor),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),

            separatorView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
