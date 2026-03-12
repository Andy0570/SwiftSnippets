//
//  HeaderSectionTitleVM.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import Foundation
import MagazineLayout

struct HeaderSectionTitleVM: MagazineSupplementaryDataType {
    let heightMode: MagazineLayoutHeaderHeightMode = .static(height: 64)

    let title: String
    let subtitle: String

    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }

    var diffHash: Int {
        return title.hashValue
    }

    func configurator() -> SupplementaryCellConfigurator {
        return HeaderSectionTitleConfigurator(item: self)
    }
}
