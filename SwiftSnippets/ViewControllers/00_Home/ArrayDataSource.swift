//
//  ArrayDataSource.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/12/6.
//

import UIKit

class ArrayDataSource: NSObject, UITableViewDataSource {
    private var sections: [Section]!
    private var cellReuseIdentifier: String!
    var cellConfigureClosure: ((UITableViewCell, Cell) -> Void)?

    init(sections: [Section], cellReuseIdentifier: String) {
        self.sections = sections
        self.cellReuseIdentifier = cellReuseIdentifier
    }

    func getSectionItem(at section: Int) -> Section {
        return sections[section]
    }

    func getCellItem(at indexPath: IndexPath) -> Cell {
        let section = getSectionItem(at: indexPath.section)
        return section.cells[indexPath.row]
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = getSectionItem(at: section)
        return section.cells.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = getSectionItem(at: section)
        return section.title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let item = getCellItem(at: indexPath)
        self.cellConfigureClosure?(cell, item)
        return cell
    }
}
