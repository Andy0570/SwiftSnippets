//
//  RowTextVM.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import Foundation
import MagazineLayout

struct RowTextVM: MagazineCellDataType {
    var sizeMode: MagazineLayoutItemSizeMode {
        return MagazineLayoutItemSizeMode(
            widthMode: .fullWidth(respectsHorizontalInsets: true),
            heightMode: .dynamic
        )
    }

    let text: String

    init(text: String) {
        self.text = text
    }

    var diffHash: Int {
        return text.hashValue
    }

    func configurator() -> CellConfigurator {
        return RowTextConfigurator(item: self)
    }

    func didSelect() {
        //
    }
}
