//
//  MultipleSelectionViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/2/5.
//

import UIKit

/// 支持多选的 UITableView 列表
final class MultipleSelectionViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 44
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .singleLine
        return tableView
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("next", for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.setBackgroundColor(color: UIColor.brown, forState: .normal)
        return button
    }()

    private var viewModel = ViewModel()

    override func loadView() {
        super.loadView()

        view.addSubview(tableView)
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            nextButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TableView 中的多选功能"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = UIColor.systemBackground

        tableView.backgroundColor = UIColor.systemBackground
        tableView.dataSource = viewModel
        tableView.delegate = viewModel

        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)

        viewModel.didToggleSelection = { [weak self] hasSelection in
            self?.nextButton.isEnabled = hasSelection
        }
        self.nextButton.isEnabled = false
    }

    // MARK: - Action
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print(viewModel.selectedItems.map { $0.title })
    }
}
