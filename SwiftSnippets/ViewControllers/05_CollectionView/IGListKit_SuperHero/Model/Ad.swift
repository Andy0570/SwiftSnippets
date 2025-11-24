//
//  Ad.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/11/24.
//

import IGListKit

class Ad: ListDiffable {
    private var identifier: String = UUID().uuidString
    private(set) var description: String

    init(description: String) {
        self.description = description
    }

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Ad else {
            return false
        }
        return self.identifier == object.identifier
    }
}
