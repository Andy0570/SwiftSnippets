//
//  RWAlbumDetailItem.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/4.
//

import Foundation

class RWAlbumDetailItem: Hashable {
    let photoURL: URL
    let thumbnailURL: URL
    let subitems: [RWAlbumDetailItem]
    
    init(photoURL: URL, thumbnailURL: URL, subitems: [RWAlbumDetailItem] = []) {
        self.photoURL = photoURL
        self.thumbnailURL = thumbnailURL
        self.subitems = subitems
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: RWAlbumDetailItem, rhs: RWAlbumDetailItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private let identifier = UUID()
}
