//
//  UITableViewCellExtensions.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/12/6.
//

import UIKit

protocol TableViewCellConfigureDelegate {
    var imageName: String { get }
    var title: String { get }
    var description: String { get }
}

extension UITableViewCell {
    func configureForCell(cell: TableViewCellConfigureDelegate) {
        self.imageView?.image = UIImage(named: cell.imageName)
        self.textLabel?.text = cell.title
        self.detailTextLabel?.text = cell.description
        self.accessoryType = .disclosureIndicator
    }
}
