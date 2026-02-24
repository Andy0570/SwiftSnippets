//
//  MagazineLayoutSection.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/1/23.
//

import MagazineLayout

struct MagazineLayoutSection {
    struct HeaderInfo {
        let item: SupplementaryCellConfigurator?
        let visibilityMode: MagazineLayoutHeaderVisibilityMode

        static func hidden() -> HeaderInfo {
            return .init(item: nil, visibilityMode: .hidden)
        }
    }

    struct FooterInfo {
        let item: SupplementaryCellConfigurator?
        let visibilityMode: MagazineLayoutFooterVisibilityMode

        static func hidden() -> FooterInfo {
            return .init(item: nil, visibilityMode: .hidden)
        }
    }

    struct BackgroundInfo {
        let item: SupplementaryCellConfigurator?
        let visibilityMode: MagazineLayoutBackgroundVisibilityMode

        static func hidden() -> BackgroundInfo {
            return .init(item: nil, visibilityMode: .hidden)
        }
    }

    let identifier: String
    let header: HeaderInfo
    let footer: FooterInfo
    let items: [CellConfigurator]
    let background: BackgroundInfo
    let sectionInset: UIEdgeInsets
    let itemInset: UIEdgeInsets

    init(identifier: String,
         items: [CellConfigurator],
         header: HeaderInfo,
         footer: FooterInfo,
         background: BackgroundInfo,
         sectionInset: UIEdgeInsets = .zero,
         itemInset: UIEdgeInsets = .zero) {
        self.identifier = identifier
        self.header = header
        self.footer = footer
        self.items = items
        self.background = background
        self.sectionInset = sectionInset
        self.itemInset = itemInset
    }
}
