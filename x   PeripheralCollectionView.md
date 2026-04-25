```
//
//  PeripheralCollectionView.swift
//  FoxEssProject
//
//  Created by huqilin on 2025/7/24.
//

import UIKit

/// 当蓝牙搜索到外围设备时，在 CollectionView 中显示
final class PeripheralCollectionView: BaseView {
    // MARK: - Type Aliases
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, BLEPeripheral>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, BLEPeripheral>
    
    // MARK: - Nested Types
    private enum Section: Hashable {
        case main
    }
    
    // MARK: - Public
    var headerSearchButtonTappedAction: (ClosureVoid)?
    var peripherals: [BLEPeripheral] = [] {
        didSet {
            applySnapshot()
        }
    }
    private lazy var dataSource = makeDataSource()
    
    // MARK: - Controls
    private(set) var headerView: PeripheralCollectionHeaderView!
    private var collectionView: UICollectionView!
    
    override func setupView() {
        backgroundColor = UIColor.clear
        
        // bluetoothSearchView
        headerView = PeripheralCollectionHeaderView(frame: .zero)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.isHidden = true
        addSubview(headerView)
        
        // collectionView
        let layout = makeCollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = ColorPalette.bgLayout
        addSubview(collectionView)
        
        collectionView.register(PeripheralCollectionViewCard.self, forCellWithReuseIdentifier: PeripheralCollectionViewCard.reuseIdentifier)
        
        // 连接集合视图与数据源
        collectionView.dataSource = dataSource
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 48),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
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
    
    // 告诉集合视图，要显示哪些 headers 和 items
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, peripheral in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeripheralCollectionViewCard.reuseIdentifier, for: indexPath) as? PeripheralCollectionViewCard else {
                fatalError("Unable to dequeue 'PeripheralCollectionViewCard'")
            }
            cell.configureWith(peripheral.sn)
            return cell
        }
        return dataSource
    }
    
    private func applySnapshot(animated: Bool = true) {
        // 创建一个 SnapShot 并填充数据
        var snapshot = SnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems(peripherals, toSection: .main)
        // 将 SnapShot 应用到数据源，以显示数据
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

```

