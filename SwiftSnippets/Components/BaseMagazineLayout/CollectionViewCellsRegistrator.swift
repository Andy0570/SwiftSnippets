//
//  CollectionViewCellsRegistrator.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/1/23.
//

import MagazineLayout

final class CollectionViewCellsRegistrator {
    private(set) weak var collectionView: UICollectionView?
    private var registeredIdentifiers = Set<String>()

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    func registerCells(for sections: [MagazineLayoutSection]) {
        sections.forEach { section in
            // 注册 Header
            if let headerItem = section.header.item,
                registeredIdentifiers.contains(type(of: headerItem).cellReuseIdentifier) == false,
                let headerType = type(of: headerItem).cellType as? (UICollectionReusableView & Reusable).Type {
                self.registerSupplementaryView(headerType, kind: MagazineLayout.SupplementaryViewKind.sectionHeader)
            }

            // 注册 Footer
            if let footerItem = section.footer.item,
                registeredIdentifiers.contains(type(of: footerItem).cellReuseIdentifier) == false,
                let footerType = type(of: footerItem).cellType as? (UICollectionReusableView & Reusable).Type {
                self.registerSupplementaryView(footerType, kind: MagazineLayout.SupplementaryViewKind.sectionFooter)
            }

            // 注册 Background
            if let backgroundItem = section.background.item,
                registeredIdentifiers.contains(type(of: backgroundItem).cellReuseIdentifier) == false,
                let backgroundType = type(of: backgroundItem).cellType as? (UICollectionReusableView & Reusable).Type {
                self.registerSupplementaryView(backgroundType, kind: MagazineLayout.SupplementaryViewKind.sectionBackground)
            }

            // 注册普通 Cell
            self.register(cellConfigs: section.items)
        }
    }

    func register(cellConfigs: [CellConfigurator]) {
        cellConfigs.forEach { config in
            if let cellType = type(of: config).cellType as? (UICollectionViewCell & Reusable).Type,
               registeredIdentifiers.contains(cellType.reuseIdentifier) == false {
                self.registerCell(cellType)
            }
        }
    }

    // MARK: - Private

    /// 注册重用 SupplementaryView（支持 Header / Footer），自动适配 Nib 和 Class
    private func registerSupplementaryView<T: UICollectionReusableView & Reusable>(_ type: T.Type, kind: String) {
        collectionView?.registerReusableSupplementaryView(type, ofKind: kind)
        registeredIdentifiers.insert(type.reuseIdentifier)
    }

    /// 注册重用 Cell，自动适配 Nib 类型和 Class 类型
    private func registerCell<T: UICollectionViewCell & Reusable>(_ type: T.Type) {
        collectionView?.registerReusableCell(type)
        registeredIdentifiers.insert(type.reuseIdentifier)
    }
}
