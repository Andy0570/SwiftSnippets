//
//  RowHeadline1VM.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import Foundation
import MagazineLayout

struct RowHeadline1VM: MagazineCellDataType {
    var sizeMode: MagazineLayoutItemSizeMode {
        return MagazineLayoutItemSizeMode(
            widthMode: .fullWidth(respectsHorizontalInsets: true),
            heightMode: .dynamic
        )
    }

    let title: String

    init(title: String) {
        self.title = title
    }

    var diffHash: Int {
        return title.hashValue
    }

    func configurator() -> CellConfigurator {
        return RowHeadline1Configurator(item: self)
    }

    func didSelect() {
        //
    }
}
