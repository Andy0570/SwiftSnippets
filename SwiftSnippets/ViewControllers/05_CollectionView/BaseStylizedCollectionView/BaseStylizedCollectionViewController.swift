//
//  BaseStylizedCollectionViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/27.
//

import UIKit

final class BaseStylizedCollectionViewController: UIViewController {
    private var iconSet: [Icon] = [
        Icon(name: "candle", price: 3.99, isFeatured: false),
        Icon(name: "cat", price: 2.99, isFeatured: true),
        Icon(name: "dribbble", price: 1.99, isFeatured: false),
        Icon(name: "ghost", price: 4.99, isFeatured: false),
        Icon(name: "hat", price: 2.99, isFeatured: false),
        Icon(name: "owl", price: 5.99, isFeatured: true),
        Icon(name: "pot", price: 1.99, isFeatured: false),
        Icon(name: "pumkin", price: 0.99, isFeatured: false),
        Icon(name: "rip", price: 7.99, isFeatured: false),
        Icon(name: "skull", price: 8.99, isFeatured: false),
        Icon(name: "sky", price: 0.99, isFeatured: false),
        Icon(name: "toxic", price: 2.99, isFeatured: false)
    ]

    // MARK: - Type Aliases
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionType, Icon>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, Icon>

    // 使用 Enum 枚举类型定义 Section
    private enum SectionType {
        case all
    }

    private var collectionView: UICollectionView!

    // 使用 lazy 修饰该变量，只有实例初始化完成之后，才能检索该变量
    private lazy var dataSource = makeDataSource()

    // 在 loadView() 方法中实例化视图并添加布局约束
    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.white

        // collectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemGroupedBackground
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // 在 viewDidLoad() 方法中配置视图
    override func viewDidLoad() {
        super.viewDidLoad()

        // 注册重用 cell for nib
        collectionView.register(
            BaseStylizedCollectionViewCell.self,
            forCellWithReuseIdentifier: BaseStylizedCollectionViewCell.reuseIdentifier
        )

        // 连接集合视图与数据源
        collectionView.dataSource = dataSource
        updateSnapshot()
    }

    // 每行显式两个 Cell
    private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(162))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(162))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(16)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func makeDataSource() -> DataSource {
        // 创建 UICollectionViewDiffableDataSource<Section, Icon> 实例，它是一个泛型对象，能够处理集合中不同的 section 和 item。
        // <Section, Icon> 中的 Section 表示我们使用自定义的 Section 枚举类型处理 section 部分。
        // <Section, Icon> 中的 Icon 表示我们使用 Icon 类型处理 cell 数据。
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, icon -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseStylizedCollectionViewCell.reuseIdentifier, for: indexPath) as? BaseStylizedCollectionViewCell else {
                fatalError("Unable to dequeue 'BaseStylizedCollectionViewCell'")
            }

            cell.configure(with: "$\(icon.price)", imageName: icon.name)
            return cell
        }

        return dataSource
    }

    private func updateSnapshot(animated: Bool = false) {
        // 创建一个 NSDiffableDataSourceSnapshot 快照并填充数据
        var snapshot = Snapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(iconSet, toSection: .all)
        // 将快照应用到数据源
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}
