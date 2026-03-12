//
//  CardPhotoThumbnailVM.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import Foundation
import MagazineLayout

struct CardPhotoThumbnailVM: MagazineCellDataType {
    var sizeMode: MagazineLayoutItemSizeMode {
        return MagazineLayoutItemSizeMode(widthMode: .thirdWidth, heightMode: .static(height: 120))
    }

    let url: String

    init(url: String) {
        self.url = url
    }

    var diffHash: Int {
        return url.hashValue
    }

    func configurator() -> CellConfigurator {
        return CardPhotoThumbnailConfigurator(item: self)
    }

    func didSelect() {
        //
    }
}
