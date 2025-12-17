//
//  DiffableDatasourceTableView.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/26.
//

import UIKit

/**
 使用 UITableView 建立 diffable 数据源。
 
 参考：
 <https://www.notion.so/andy0570/UITableView-diffable-225973ced06c80aa98cedf6be5fd115b?source=copy_link>
 */

// Diffable 数据源要求其底层模型必须遵守 Hashable 协议
struct VideoGame: Hashable {
    let id = UUID()
    let name: String
}

extension VideoGame {
    static var data = [
        VideoGame(name: "Mass Effect"),
        VideoGame(name: "Mass Effect 2"),
        VideoGame(name: "Mass Effect 3"),
        VideoGame(name: "ME: Andromeda"),
        VideoGame(name: "ME: Remaster")
    ]
}

/**
 查看 UITableViewDiffableDataSource 头文件声明：

 open class UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> : NSObject, UITableViewDataSource where SectionIdentifierType : Hashable, ItemIdentifierType : Hashable { }

 1. `UITableViewDiffableDataSource` 是 `NSObject` 的子类对象，同时它遵守 `UITableViewDataSource` 协议。它用来维护 TableView 的数据源。
 2. 其中，`SectionIdentifierType` 和 `ItemIdentifierType` 是它包含的两个泛型类型。这两个泛型类型被约束为需要遵守 `Hashable` 协议。

 typealias UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider = (_ tableView: UITableView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifierType) -> UITableViewCell?

 Diffable DataSource 负责当前数据源配置，DataSource Snapshot 负责变更后的数据源处理。
 Diffable DataSource 通过调用自身 `apply` 方法将 DataSource Snapshot 变更后的数据更新同步到 UITableView 的 UI。
 
 Diffable DataSource 在初始化时可能看起来有点令人生畏，所以我发现通过为你使用的每个数据源使用类型别名来阅读它会更容易。
 虽然这不是必需的，但我认为这里值得的。
 */
typealias TableDataSource = UITableViewDiffableDataSource<Int, VideoGame>

final class DiffableDatasourceTableView: UIViewController {
    let videogames: [VideoGame] = VideoGame.data
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    lazy var dataSource: TableDataSource = {
        let dataSource = TableDataSource(tableView: tableView) { tableView, indexPath, model -> UITableViewCell? in
            // 在 cellProvider 闭包中处理本质上是 cellForRow: 的内容
            let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
            cell.textLabel?.text = model.name
            return cell
        }
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        tableView.register(cellWithClass: UITableViewCell.self)
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Diffable 数据源使用快照的概念。这就是它的易用性和强大的来源。
        // 使用 snapshot 对 dataSource 进行差异化比对，进行动态更新。
        // 在这里，你只需要考虑现在应该如何对数据进行建模。在这种情况下，我们已经获得了第一次加载所需的数据，因此我们将传递所有内容并应用它：
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(videogames, toSection: 0)
        dataSource.apply(snapshot)
    }
}
