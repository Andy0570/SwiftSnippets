//
//  CornerRadiusTableViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/2/5.
//

import UIKit

/// 在 Swift 5 中实现支持圆角和阴影的列表视图
/// 参考：<https://simaspavlos.medium.com/round-corners-and-shadow-in-uitableviewcell-swift-5-8eb903bf38a1>
final class CornerRadiusTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置圆角和阴影"
        tableView.backgroundColor = UIColor.systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44

        tableView.register(CornerRadiusTableViewCell.nib, forCellReuseIdentifier: CornerRadiusTableViewCell.identifier)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CornerRadiusTableViewCell.identifier, for: indexPath) as? CornerRadiusTableViewCell else {
            fatalError("Could not dequeue cell: CornerRadiusTableViewCell, make sure the cell is registered with table view")
        }

        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "在 cell 上同时设置圆角和阴影"
        case 1:
            cell.titleLabel.text = "最佳实践"
        case 2:
            cell.titleLabel.text = "分别在不同的视图层上设置圆角和阴影"
        case 3:
            cell.titleLabel.text = "1.在根视图层上设置阴影"
        case 4:
            cell.titleLabel.text = "2.在自定义容器视图层上设置圆角"
        default:
            cell.titleLabel.text = "默认名称"
        }
        return cell
    }
}
