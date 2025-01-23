//
//  ItemListViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/22.
//

import UIKit

/// 创建自定义日历控件
/// 参考：<https://www.kodeco.com/10787749-creating-a-custom-calendar-control-for-ios>
class ItemListViewController: UITableViewController {
    // MARK: Diffable Data Source Setup

    enum Section {
        case main
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, ChecklistItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ChecklistItem>

    // MARK: - Properties

    private lazy var dataSource = makeDataSource()
    private lazy var items = ChecklistItem.exampleItems

    private var searchQuery: String? {
        didSet {
            applySnapshot()
        }
    }

    // MARK: - Controller Setup

    private lazy var searchController = makeSearchController()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Checkmate"

        navigationItem.searchController = searchController
        definesPresentationContext = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .done,
            target: self,
            action: #selector(didTapNewItemButton)
        )
        navigationItem.rightBarButtonItem?.accessibilityLabel = "New Item"

        tableView.register(ChecklistItemTableViewCell.self, forCellReuseIdentifier: ChecklistItemTableViewCell.reuseIdentifier)

        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        applySnapshot(animatingDifferences: false)
    }

    // 点击导航栏添加按钮，弹窗添加新的条目
    @objc func didTapNewItemButton() {
        let newItemAlert = UIAlertController(
            title: "New Item",
            message: "What would you like to do today?",
            preferredStyle: .alert
        )
        newItemAlert.addTextField { textField in
            textField.placeholder = "Item Text"
        }
        newItemAlert.addAction(UIAlertAction(title: "Create Item", style: .default, handler: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            // 如果标题为空，显示错误弹窗
            guard let title = newItemAlert.textFields?[0].text, !title.isEmpty else {
                let errorAlert = UIAlertController(
                    title: "Error",
                    message: "You can't leave the title empty.",
                    preferredStyle: .alert
                )
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                strongSelf.present(errorAlert, animated: true)
                return
            }

            // 添加新的条目
            strongSelf.items.append(ChecklistItem(title: title, date: Date()))

            self?.applySnapshot()
        }))
        newItemAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(newItemAlert, animated: true)
    }
}

// MARK: - Table View Methods

extension ItemListViewController {
    func applySnapshot(animatingDifferences: Bool = true) {
        var items: [ChecklistItem] = self.items

        // 如果存在搜索查询，则执行过滤
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            items = items.filter { item in
                return item.title.lowercased().contains(searchQuery.lowercased())
            }
        }

        // 根据日期排序
        items = items.sorted { one, two in
            return one.date < two.date
        }
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: ChecklistItemTableViewCell.reuseIdentifier, for: indexPath) as? ChecklistItemTableViewCell
            cell?.item = item
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ItemDetailViewController(item: items[indexPath.row]), animated: true)
    }

    // MARK: Contexual Menus

    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self, let item = self.dataSource.itemIdentifier(for: indexPath) else {
                return nil
            }

            // 执行右划删除操作
            let deleteAction = UIAction(title: "Delete Item", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.items.removeAll { existingItem in
                    return existingItem == item
                }

                self.applySnapshot()
            }

            return UIMenu(title: item.title.truncatedPrefix(12), image: nil, children: [deleteAction])
        }

        return configuration
    }
}

// MARK: Search Controller Setup

extension ItemListViewController: UISearchResultsUpdating {
    func makeSearchController() -> UISearchController {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search Items"
        return controller
    }

    func updateSearchResults(for searchController: UISearchController) {
        searchQuery = searchController.searchBar.text
    }
}
