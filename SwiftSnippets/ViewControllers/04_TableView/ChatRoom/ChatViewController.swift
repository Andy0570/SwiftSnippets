//
//  ChatViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/26.
//

import UIKit

/// Data Source 新特性：基于 Diffable 实现局部刷新
/// 参考：<https://xiaozhuanlan.com/topic/9158203647>
class ChatViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var dataSource: UITableViewDiffableDataSource<ChatSection, ChatMessage>?
    var currentSnapshot = NSDiffableDataSourceSnapshot<ChatSection, ChatMessage>()
    var chatController = ChatDataController()
    var hodler: Any?
    static let reuseIdentifier = "reuse-identifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "聊天室"
        configureTableView()
        configureDataSource()
        updateUI()
    }
}

extension ChatViewController {
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ChatViewController.reuseIdentifier)
    }

    func configureDataSource() {
        // 使用 Combine 将变更数据状态分发出来，让 ChatViewController 订阅然后更新 UI。
        hodler = chatController.didChange.sink { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.updateUI()
        }

        self.dataSource = UITableViewDiffableDataSource<ChatSection, ChatMessage>(tableView: tableView, cellProvider: { tableView, indexPath, item -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatViewController.reuseIdentifier, for: indexPath)
            let name = item.isME ? item.userName : "\(item.userName)\(indexPath.row)"
            cell.textLabel?.text = "\(name): \(item.msgContent)"
            cell.textLabel?.numberOfLines = 0
            return cell
        })
        self.dataSource?.defaultRowAnimation = .fade
    }

    func updateUI(animated: Bool = true) {
        // 将变更后的数据交给 Snapshot。
        currentSnapshot = NSDiffableDataSourceSnapshot<ChatSection, ChatMessage>()

        let items = chatController.displayMsg
        currentSnapshot.appendSections([.socket])
        currentSnapshot.appendItems(items, toSection: .socket)

        // 通过 dataSource 的 apply 方法实现数据刷新同步 UI。
        self.dataSource?.apply(currentSnapshot, animatingDifferences: animated)
        self.tableView.scrollToRow(at: IndexPath(row: currentSnapshot.numberOfItems(inSection: .socket) - 1, section: 0), at: .bottom, animated: true)
    }
}
