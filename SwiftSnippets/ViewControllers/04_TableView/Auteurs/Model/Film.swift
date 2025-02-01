//
//  Film.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/2/1.
//

import Foundation

struct Film: Codable {
    let title: String
    let year: String
    let poster: String
    let plot: String
    var isExpanded: Bool

    // 自定义 init 方法，设置 isExpanded 为 false
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.year = try container.decode(String.self, forKey: .year)
        self.poster = try container.decode(String.self, forKey: .poster)
        self.plot = try container.decode(String.self, forKey: .plot)

        self.isExpanded = false
    }
}
