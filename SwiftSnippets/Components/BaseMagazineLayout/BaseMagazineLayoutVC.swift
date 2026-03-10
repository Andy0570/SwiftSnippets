//
//  BaseMagazineLayoutVC.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/1/23.
//

import MagazineLayout

protocol PBaseMagazineLayoutVC: UICollectionViewDelegateMagazineLayout, UICollectionViewDataSource {
    /// 当前的数据源
    var sections: [MagazineLayoutSection] { get }
    
    /// CollectionView
    var collectionView: UICollectionView { get }
    
    /// 选中某个 item 时回调
    var onDidSelectItem: ((CellConfigurator) -> Void)? { get set }
}

class BaseMagazineLayoutVC: UIViewController, PBaseMagazineLayoutVC {
    
    var sections: [MagazineLayoutSection] = [] {
        didSet {
            cellsRegistrator.registerCells(for: sections)
            collectionView.reloadData()
        }
    }
    
    var onDidSelectItem: ((CellConfigurator) -> Void)?
    
    private lazy var cellsRegistrator = CollectionViewCellsRegistrator(collectionView: self.collectionView)
    
    lazy var collectionView: UICollectionView = {
        let layout = MagazineLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .always
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        self.view.insertSubview(self.collectionView, at: 0)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegateMagazineLayout

extension BaseMagazineLayoutVC: UICollectionViewDelegateMagazineLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeModeForItemAt indexPath: IndexPath) -> MagazineLayoutItemSizeMode {
        return sections[indexPath.section].items[indexPath.row].sizeMode
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, visibilityModeForHeaderInSectionAtIndex index: Int) -> MagazineLayoutHeaderVisibilityMode {
        return sections[index].header.visibilityMode
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, visibilityModeForFooterInSectionAtIndex index: Int) -> MagazineLayoutFooterVisibilityMode {
        return sections[index].footer.visibilityMode
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, visibilityModeForBackgroundInSectionAtIndex index: Int) -> MagazineLayoutBackgroundVisibilityMode {
        return sections[index].background.visibilityMode
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, horizontalSpacingForItemsInSectionAtIndex index: Int) -> CGFloat {
        return sections[index].itemInset.right
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, verticalSpacingForElementsInSectionAtIndex index: Int) -> CGFloat {
        return sections[index].itemInset.bottom
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsForSectionAtIndex index: Int) -> UIEdgeInsets {
        return sections[index].sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsForItemsInSectionAtIndex index: Int) -> UIEdgeInsets {
        return sections[index].itemInset
    }
}

// MARK: - UICollectionViewDataSource

extension BaseMagazineLayoutVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellConfigurator = sections[indexPath.section].items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: cellConfigurator).cellReuseIdentifier, for: indexPath)
        cellConfigurator.configure(cell: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        if let sectionHeaderItem = section.header.item, kind == MagazineLayout.SupplementaryViewKind.sectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type(of: sectionHeaderItem).cellReuseIdentifier, for: indexPath)
            sectionHeaderItem.configure(cell: cell)
            return cell
        } else if let sectionFooterItem = section.footer.item, kind == MagazineLayout.SupplementaryViewKind.sectionFooter {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type(of: sectionFooterItem).cellReuseIdentifier, for: indexPath)
            sectionFooterItem.configure(cell: cell)
            return cell
        }
        
        // TODO: Background Item.
        
        fatalError("Not supported")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellConfigurator = sections[indexPath.section].items[indexPath.row]
        onDidSelectItem?(cellConfigurator) // 用闭包回调
        cellConfigurator.didSelect()
    }
}
