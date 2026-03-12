//
//  CardsHorizontalRowVM.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import Foundation
import MagazineLayout

final class RowHorizontalCardsCollectionVM: MagazineCellDataType {
    private(set) lazy var sizeMode = MagazineLayoutItemSizeMode(widthMode: .fullWidth(respectsHorizontalInsets: true), heightMode: .static(height: self.itemHeight))

    let items: [MagazineCellDataType]

    let itemWidth: CGFloat
    let itemHeight: CGFloat
    let itemsSpacing: CGFloat

    var configurators: [CellConfigurator] {
        return items.map { $0.configurator() }
    }

    init(items: [MagazineCellDataType], itemWidth: CGFloat, itemHeight: CGFloat, itemsSpacing: CGFloat) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        self.itemsSpacing = itemsSpacing
    }

    var diffHash: Int {
        return items.map { $0.diffHash }.reduce(0, ^)
    }

    func didSelect() {
        // do nothing as this cell is just a container
    }

    func configurator() -> CellConfigurator {
        return RowHorizontalCardsCollectionConfigurator(item: self)
    }
}
