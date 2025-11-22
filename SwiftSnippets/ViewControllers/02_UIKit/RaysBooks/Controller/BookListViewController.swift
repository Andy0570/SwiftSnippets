//
//  BookListViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/13.
//

import UIKit

/**
 UIButton Configuration 入门教程
 
 参考：<https://www.kodeco.com/27854768-uibutton-configuration-tutorial-getting-started>
 */
final class BookListViewController: UIViewController {
    // MARK: - Views

    private lazy var collectionView: UICollectionView = {
        let tempLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: tempLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - DataSource

    typealias CollectionDataSource = UICollectionViewDiffableDataSource<Section, Book>
    typealias CollectionSnapshot = NSDiffableDataSourceSnapshot<Section, Book>

    enum Section {
        case main
    }

    private lazy var dataSource = makeDataSource()

    // MARK: - Variables & Initializers

    private var books: [Book]
    private var config: Configuration

    /// A list of identifiers for the books in the cart
    private var booksInCart: [UUID] = []

    struct Configuration {
        let showAddButtons: Bool

        static let `default` = Configuration(showAddButtons: true)
    }

    init(books: [Book], config: Configuration = .default) {
        self.books = books
        self.config = config

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Books"

        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true

        let cartButton = UIBarButtonItem(
            title: "Cart",
            image: UIImage(systemName: "cart"),
            primaryAction: UIAction { _ in
                let cartVC = CartViewController(books: self.books.filter { book in
                    return self.isInCart(book: book)
                })
                self.present(UINavigationController(rootViewController: cartVC), animated: true)
            }
        )

        let accountButton = UIBarButtonItem(
            title: "Sign-in",
            image: UIImage(systemName: "person.crop.circle"),
            primaryAction: UIAction { _ in
                self.present(UINavigationController(rootViewController: SignInViewController()), animated: true)
            }
        )
        navigationItem.rightBarButtonItems = [accountButton, cartButton]

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.collectionViewLayout = makeLayout()
        applySnapshot(animatingDifferences: false)
    }

    private func toggleCartStatus(for book: Book) -> Bool {
        if let index = booksInCart.firstIndex(of: book.id) {
            booksInCart.remove(at: index)
        } else {
            booksInCart.append(book.id)
        }

        return isInCart(book: book)
    }

    private func isInCart(book: Book) -> Bool {
        return booksInCart.contains(book.id)
    }
}

// MARK: - DataSource Implementation

extension BookListViewController {
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = CollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(books)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    func makeDataSource() -> CollectionDataSource {
        collectionView.register(
            BookCollectionCell.self,
            forCellWithReuseIdentifier: BookCollectionCell.reuseIdentifier
        )

        return CollectionDataSource(collectionView: collectionView) { collectionView, indexPath, book in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BookCollectionCell.reuseIdentifier,
                for: indexPath
            ) as? BookCollectionCell

            cell?.book = book
            cell?.showAddButton = self.config.showAddButtons
            cell?.isBookInCart = self.isInCart(book: book)

            cell?.didTapCartButton = {
                return self.toggleCartStatus(for: book)
            }

            return cell
        }
    }
}

// MARK: - Layout Implementation

extension BookListViewController {
    func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(160)
            )

            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }

        return layout
    }
}
