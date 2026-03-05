//
//  RWAlbumItem.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/4.
//

import Foundation

class RWAlbumItem: Hashable {
    let albumURL: URL
    let albumTitle: String
    let imageItems: [RWAlbumDetailItem]

    init(albumURL: URL, imageItems: [RWAlbumDetailItem] = []) {
        self.albumURL = albumURL
        self.albumTitle = albumURL.lastPathComponent.displayNicely
        self.imageItems = imageItems
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: RWAlbumItem, rhs: RWAlbumItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    private let identifier = UUID()
}
