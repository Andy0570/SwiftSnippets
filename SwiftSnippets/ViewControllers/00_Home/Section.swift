//
//  Section.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/12/6.
//

import Foundation

struct Section: Codable {
    let title: String
    let cells: [Cell]

    static func sectionsFromBundle() -> [Section] {
        var sections: [Section] = []

        // 加载 Bundle 包中的 json 文件，并通过 Codable 解析为模型数据
        guard let url = Bundle.main.url(forResource: "home", withExtension: "json") else {
            fatalError("Error: Unable to find specified JSON file!")
        }

        do {
            let data = try Data(contentsOf: url)
            sections = try JSONDecoder().decode([Section].self, from: data)
        } catch {
            fatalError("Error occured during parsing, \(error)")
        }

        return sections
    }
}

struct Cell: Codable, TableViewCellConfigureDelegate {
    let imageName: String
    let title: String
    let description: String
    let className: String
}
