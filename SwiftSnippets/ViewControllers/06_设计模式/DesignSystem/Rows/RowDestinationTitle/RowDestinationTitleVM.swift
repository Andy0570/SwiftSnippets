//
//  RowDestinationTitleVM.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import Foundation
import MagazineLayout

final class RowDestinationTitleVM: MagazineCellDataType {
    var sizeMode: MagazineLayoutItemSizeMode {
        return MagazineLayoutItemSizeMode(widthMode: .fullWidth(respectsHorizontalInsets: true),
                                          heightMode: .static(height: 72))
    }

    let title: String

    init(title: String) {
        self.title = title
    }

    var diffHash: Int {
        return title.hashValue
    }

    func configurator() -> CellConfigurator {
        return RowDestinationTitleConfigurator(item: self)
    }

    func didSelect() {
        //
    }
}
