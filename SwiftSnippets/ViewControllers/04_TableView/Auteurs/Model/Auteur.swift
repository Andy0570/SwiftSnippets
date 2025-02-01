//
//  Auteur.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/2/1.
//

import Foundation

struct Auteurs: Codable {
    let auteurs: [Auteur]
}

// 导演
struct Auteur: Codable {
    let name: String
    let bio: String
    let source: String
    let image: String
    var films: [Film]

    static func auteursFromBundle() -> [Auteur] {
        var auteurs: [Auteur] = []
        // 加载 Bundle 包中的 json 文件，并通过 Codable 解析为模型数据
        guard let url = Bundle.main.url(forResource: "auteurs", withExtension: "json") else {
            fatalError("Error: Unable to find specified file: 'auteurs.json'!")
        }

        do {
            let data = try Data(contentsOf: url)
            let json = try JSONDecoder().decode(Auteurs.self, from: data)
            auteurs = json.auteurs
        } catch {
            fatalError("Error occured during parsing, \(error)")
        }

        return auteurs
    }
}
