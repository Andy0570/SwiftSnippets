//
//  HomeViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/12/6.
//

import UIKit

class HomeViewController: UIViewController {
    private let sections = Section.sectionsFromBundle()
    private var arrayDataSource: ArrayDataSource! {
        didSet {
            tableView.dataSource = arrayDataSource
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.backgroundColor = .systemBackground
        tableView.register(cellWithClass: UITableViewCell.self)
        tableView.delegate = self
        return tableView
    }()

    // 在 loadView() 方法中实例化视图并添加布局约束
    override func loadView() {
        super.loadView()

        // 如果我们添加了 scrollviews，这个技巧可以防止导航栏折叠
        // view.addSubview(UIView(frame: .zero))

        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // 在 viewDidLoad() 方法中配置视图
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"

        // 加载数据源，设置代理
        arrayDataSource = ArrayDataSource(sections: sections, cellReuseIdentifier: String(describing: UITableViewCell.self))
        arrayDataSource.cellConfigureClosure = { tableViewCell, cell in
            tableViewCell.configureForCell(cell: cell)
        }
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let item = self.arrayDataSource?.getCellItem(at: indexPath),
            let controller = viewControllerFromString(viewControllerName: item.className) {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension NSObject {
    // <https://stackoverflow.com/questions/46806969/create-a-uiviewcontroller-class-instance-from-string-view-controller-string-nam>
    func viewControllerFromString(viewControllerName: String) -> UIViewController? {
        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            // printLog("CFBundleName: \(appName)")
            if let viewControllerType = NSClassFromString("\(appName).\(viewControllerName)") as? UIViewController.Type {
                return viewControllerType.init()
            }
        }

        return nil
    }
}
