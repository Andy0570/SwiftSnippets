//
//  ChecklistItem.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/22.
//

import Foundation

/// RWCalendarPicker 中的「待办清单」模型
class ChecklistItem: Hashable {
    var id: UUID
    var title: String
    var date: Date
    var completed: Bool

    init(title: String, date: Date, completed: Bool = false) {
        self.id = UUID()
        self.title = title
        self.date = date
        self.completed = completed
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension ChecklistItem {
    static var exampleItems: [ChecklistItem] = [
        ChecklistItem(title: "Complete the Diffable Data Sources tutorial on raywenderlich.com", date: Date())
    ]
}
