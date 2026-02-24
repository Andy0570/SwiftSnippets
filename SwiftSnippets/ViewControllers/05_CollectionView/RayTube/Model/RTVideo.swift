//
//  RTVideo.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/2/14.
//

import UIKit

class RTVideo: Hashable {
    var id = UUID()
    var title: String
    var thumbnail: UIImage?
    var lessonCount: Int
    var link: URL?
    
    init(title: String, thumbnail: UIImage? = nil, lessonCount: Int, link: URL? = nil) {
        self.title = title
        self.thumbnail = thumbnail
        self.lessonCount = lessonCount
        self.link = link
    }
    
    // 对给定的 Item 执行 hash 处理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: RTVideo, rhs: RTVideo) -> Bool {
        lhs.id == rhs.id
    }
}
