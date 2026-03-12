//
//  CardsHorizontalRow.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import UIKit
import MagazineLayout

typealias RowHorizontalCardsCollectionConfigurator = MagazineCellConfigurator<RowHorizontalCardsCollectionVM, RowHorizontalCardsCollection>

final class RowHorizontalCardsCollection: UICollectionViewCell, ConfigurableCell {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPrefetchingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 16)
        return collectionView
    }()

    private var items = [CellConfigurator]()
    private lazy var cellsRegistrator = CollectionViewCellsRegistrator(collectionView: self.collectionView)

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(self.collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }

        self.clipsToBounds = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: RowHorizontalCardsCollectionVM) {
        (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: item.itemWidth, height: item.itemHeight)

        let configs = item.configurators
        self.cellsRegistrator.register(cellConfigs: configs)
        (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing = item.itemsSpacing
        self.items = configs
        self.collectionView.reloadData()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.collectionView.contentOffset = CGPoint(x: -collectionView.contentInset.left, y: 0)
    }
}

extension RowHorizontalCardsCollection: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellConfigurator = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: cellConfigurator).cellReuseIdentifier, for: indexPath)
        cellConfigurator.configure(cell: cell)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellConfigurator = items[indexPath.row]
        cellConfigurator.didSelect()
    }
}
