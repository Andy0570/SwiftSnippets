//
//  CardDestinationVM.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import Foundation
import MagazineLayout

class CardDestinationVM: MagazineCellDataType {
    var sizeMode: MagazineLayoutItemSizeMode {
        return MagazineLayoutItemSizeMode(widthMode: .thirdWidth, heightMode: .static(height: 160))
    }

    let imageUrl: String
    let title: String
    let subtitle: String

    init(imageUrl: String, title: String, subtitle: String) {
        self.imageUrl = imageUrl
        self.title = title
        self.subtitle = subtitle
    }

    var diffHash: Int {
        return imageUrl.hashValue
    }

    func configurator() -> CellConfigurator {
        return CardDestinationConfigurator(item: self)
    }

    func didSelect() {
        // Push 到下一个页面
    }
}
