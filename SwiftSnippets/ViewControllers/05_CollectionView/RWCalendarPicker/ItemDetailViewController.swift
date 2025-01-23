//
//  ItemDetailViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/22.
//

import UIKit

class ItemDetailViewController: UITableViewController {
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()

    let item: ChecklistItem

    init(item: ChecklistItem) {
        self.item = item

        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground

        title = String(item.title.truncatedPrefix(16))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")

        if indexPath.row == 0 {
            cell.textLabel?.text = "Task Name"
            cell.detailTextLabel?.text = item.title
        } else {
            cell.textLabel?.text = "Due Date"
            cell.detailTextLabel?.text = dateFormatter.string(from: item.date)
        }

        cell.accessoryType = .disclosureIndicator

        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 0 {
            // !!!: 点击第一个cell，显示 Alert 弹窗更新时间

            let changeTaskNameAlert = UIAlertController(
                title: "Edit Name",
                message: "What should this task be called?",
                preferredStyle: .alert
            )
            changeTaskNameAlert.addTextField { [weak self] textField in
                guard let strongSelf = self else {
                    return
                }

                textField.text = strongSelf.item.title
                textField.placeholder = "Task Name"
            }
            changeTaskNameAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }

                guard let newTitle = changeTaskNameAlert.textFields?[0].text, !newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    return
                }

                strongSelf.item.title = newTitle
                strongSelf.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            }))

            changeTaskNameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(changeTaskNameAlert, animated: true)
        } else if indexPath.row == 1 {
            // !!!: 点击第二个cell，弹窗呈现自定义的日历选择器

            let pickerController = CalendarPickerViewController(baseDate: item.date) { [weak self] date in
                guard let strongSelf = self else {
                    return
                }

                // 选择完成后的回调，刷新列表
                strongSelf.item.date = date
                strongSelf.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
            }

            present(pickerController, animated: true)
        }
    }
}
