//
//  HeaderHeadline2VM.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import Foundation
import MagazineLayout

struct HeaderHeadline2VM: MagazineSupplementaryDataType {
    let heightMode: MagazineLayoutHeaderHeightMode = .dynamic

    let title: String

    init(title: String) {
        self.title = title
    }

    var diffHash: Int {
        return title.hashValue
    }

    func configurator() -> SupplementaryCellConfigurator {
        return HeaderHeadline2Configurator(item: self)
    }
}
