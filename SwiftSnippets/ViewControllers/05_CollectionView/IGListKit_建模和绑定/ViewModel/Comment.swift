//
//  Comment.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/11/24.
//

import IGListKit

final class Comment: ListDiffable {
    let username: String
    let text: String

    init(username: String, text: String) {
        self.username = username
        self.text = text
    }

    // MARK: - ListDiffable

    func diffIdentifier() -> any NSObjectProtocol {
        return (username + text) as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: (any ListDiffable)?) -> Bool {
        return true
    }
}
