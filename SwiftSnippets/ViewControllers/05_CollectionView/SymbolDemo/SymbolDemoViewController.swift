//
//  SymbolDemoViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/6.
//

import UIKit

/// Advances in CollectionView
/// Reference: <https://medium.com/mindful-engineering/diffable-data-source-in-uicollectionview-3a1c5577b4de>
final class SymbolDemoViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case grid
        case list
        case outline
    }

    struct Item: Hashable {
        var title: String?
        var symbol: SymbolItem?
        var isChild: Bool

        init(title: String? = nil, symbol: SymbolItem? = nil, isChild: Bool = false) {
            self.title = title
            self.symbol = symbol
            self.isChild = isChild
        }

        private let identifier = UUID()
    }

    var itemSection = ItemSection()
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var collectionView: UICollectionView! = nil

    private var gridCellRegistration: UICollectionView.CellRegistration<UICollectionViewCell, Item>!
    private var listCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Item>!
    private var outlineHeaderCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Item>!
    private var outlineSubCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Diffable Data Source"

        gridCellRegistration = makeGridCellRegistration()
        listCellRegistration = makeListCellRegistration()
        outlineHeaderCellRegistration = makeOutlineHeaderCellRegistration()
        outlineSubCellRegistration = makeOutlineSubCellRegistration()

        configureCollectionView()
        configureDataSource()
        applySnapshot()
    }
}

extension SymbolDemoViewController {
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        self.collectionView = collectionView
    }

    private func deleteItemOnSwipe(item: Item) -> UISwipeActionsConfiguration? {
        let actionHandler: UIContextualAction.Handler = { _, _, completion in
            completion(true)

            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([item])
            self.dataSource.apply(snapshot)
        }

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: actionHandler)
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else {
                return nil
            }

            let section: NSCollectionLayoutSection
            switch sectionKind {
                // Create layout for grid section
                case .grid:
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.18), heightDimension: .fractionalWidth(0.2))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    section = NSCollectionLayoutSection(group: group)
                    section.interGroupSpacing = 10
                    section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                    section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                // Create layout for list section
                case .list:
                    var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                    configuration.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
                        guard let self, let selectedItem = self.dataSource.itemIdentifier(for: indexPath) else {
                            return nil
                        }

                        return self.deleteItemOnSwipe(item: selectedItem)
                    }
                    section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
                // Create layout for outline section
                case .outline:
                    let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
                    section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
            }
            return section
        }

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }

    // 使用 iOS 14 引入的 UICollectionView.CellRegistration API 来创建单元格注册，用于定义数据应如何在单元格中显示。
    private func makeGridCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewCell, Item> { cell, _, item in
            // ...Default content configuration
            var content = UIListContentConfiguration.cell()
            content.image = UIImage(systemName: item.symbol?.title ?? "")
            cell.contentConfiguration = content

            // ... Update background default selection color
            var bgConfig = UIBackgroundConfiguration.listPlainCell()
            bgConfig.backgroundColor = .white
            bgConfig.cornerRadius = 10
            bgConfig.strokeColor = .gray
            bgConfig.strokeWidth = 1
            cell.backgroundConfiguration = bgConfig
        }
    }

    private func makeListCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, _, item in
            var content = cell.defaultContentConfiguration()
            content.text = item.symbol?.title
            content.image = UIImage(systemName: item.symbol?.title ?? "")
            cell.contentConfiguration = content

            // ... Update background default selection color
            var bgConfig = UIBackgroundConfiguration.listPlainCell()
            bgConfig.backgroundColor = .white
            cell.backgroundConfiguration = bgConfig
        }
    }

    private func makeOutlineHeaderCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, _, item in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content

            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: headerDisclosureOption)]
        }
    }

    private func makeOutlineSubCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, _, item in
            var content = cell.defaultContentConfiguration()
            content.secondaryText = item.symbol?.title
            content.image = UIImage(systemName: item.symbol?.title ?? "")
            cell.contentConfiguration = content
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, item -> UICollectionViewCell? in
            guard let self else { return nil }
            if let section = Section(rawValue: indexPath.section) {
                switch section {
                    case .grid:
                        return collectionView.dequeueConfiguredReusableCell(using: self.gridCellRegistration, for: indexPath, item: item)
                    case .list:
                        return collectionView.dequeueConfiguredReusableCell(using: self.listCellRegistration, for: indexPath, item: item)
                    case .outline:
                        if item.isChild {
                            return collectionView.dequeueConfiguredReusableCell(using: self.outlineHeaderCellRegistration, for: indexPath, item: item)
                        } else {
                            return collectionView.dequeueConfiguredReusableCell(using: self.outlineSubCellRegistration, for: indexPath, item: item)
                        }
                }
            }
            return UICollectionViewCell()
        })
    }

    private func applySnapshot() {
        // Apply grid snapshot to data source
        var gridSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        let gridItems = itemSection.gridItem.map { Item(symbol: $0) }
        gridSnapshot.append(gridItems)
        dataSource.apply(gridSnapshot, to: .grid, animatingDifferences: false)

        // Apply list snapshot to data source
        var listSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        let listItems = itemSection.gridItem.map { Item(symbol: $0) }
        listSnapshot.append(listItems)
        dataSource.apply(listSnapshot, to: .list, animatingDifferences: false)

        var outlineSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        for item in itemSection.outlineItem {
            // Append header item to snapshot
            let outlineItem = Item(title: item.title, isChild: true)
            outlineSnapshot.append([outlineItem])

            // Add sub item to headerItem and then add sub item to outline snapshot
            let subItem = item.symbol.map { Item(symbol: $0) }
            outlineSnapshot.append(subItem, to: outlineItem)
        }
        // Apply outline snapshot to data source
        dataSource.apply(outlineSnapshot, to: .outline, animatingDifferences: false)
    }
}
