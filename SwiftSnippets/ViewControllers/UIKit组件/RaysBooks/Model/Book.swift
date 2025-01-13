//
//  Book.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/13.
//

import Foundation

struct Book: Codable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var edition: String
    var imageName: String
    var available: Bool
}
