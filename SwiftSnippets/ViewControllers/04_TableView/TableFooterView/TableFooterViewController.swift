//
//  TableFooterViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/7.
//

import UIKit

/// Dynamic table view footer with animations.
///
/// Reference: <https://medium.com/@mohammadharis_79785/dynamic-table-view-footer-with-animations-77ba0d2b9b9a>
class TableFooterViewController: UIViewController {
    struct Person {
        let name: String
    }

    private let dummyCellId = "DummmyCellId"
    private let people = [
        Person(name: "John Doe"),
        Person(name: "Alex Wonder"),
        Person(name: "Elon Musk"),
        Person(name: "Rebecca Jonson"),
        Person(name: "Harry king"),
        Person(name: "Ahmad Hussain"),
        Person(name: "App Developer"),
        Person(name: "Random Guy"),
        Person(name: "Alice Bob"),
        Person(name: "Lost Chap"),
        Person(name: "Stefan Hawk"),
        Person(name: "Justin Timber"),
        Person(name: "Nadal Virk")
    ]

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    var footerView: TableFooterView!
    // 排除首次进入页面时，tableView 触发更新，自动滑到底部的情况
    var shouldCalculateoffsetForFooter = false

    private func setup() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: dummyCellId)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        let strings = [
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            "Aenean tempus, eros in sodales iaculis, est metus ultricies ligula, sit amet sodales ipsum metus sit amet purus. Nullam euismod dui neque, in condimentum dui rutrum quis. Vivamus eget mollis purus.",
            "Donec ante ex, ullamcorper nec venenatis id, facilisis vitae nulla.",
            "Proin id faucibus eros, nec cursus ligula. Nam sit amet tincidunt lectus, quis elementum eros. Aenean vehicula non ex ut varius. ",
            "Interdum et malesuada fames ac ante ipsum primis in faucibus. Vestibulum ac placerat orci. Cras quis risus id justo aliquet tristique.",
            "Mauris urna ligula, pellentesque in nisl a, porta pulvinar dolor. Donec eget mi congue, pretium dui at, pharetra lectus.",
            "Suspendisse lacinia nulla eu urna dapibus congue. In bibendum faucibus pellentesque. Suspendisse potenti."
        ]

        footerView = TableFooterView(strings: strings)

        footerView.lessOrMoreButtonCallback = {
            self.shouldCalculateoffsetForFooter = true
            self.updateFooter()
        }

        footerView.hideButtonCallback = {
            self.shouldCalculateoffsetForFooter = true
            self.updateFooter()
        }

        footerView.backgroundColor = .red
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateFooter()
    }
}

extension TableFooterViewController {
    private func updateFooter() {
        var frame = footerView.frame
        frame.size.width = tableView.frame.size.width
        footerView.frame = frame

        footerView.layoutIfNeeded()

        let height = footerView.systemLayoutSizeFitting(CGSize(width: footerView.frame.size.width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height

        // 更新 tableFooterView 高度的同时，同步更新 tableView 的内容偏移量。
        if height != frame.size.height {
            footerView.frame.size.height = height
            if shouldCalculateoffsetForFooter {
                var currentOffset = tableView.contentOffset
                let diffHeight = height - frame.size.height
                if diffHeight > 0 {
                    currentOffset.y += diffHeight
                } else {
                    currentOffset.y -= diffHeight
                }

                tableView.contentOffset = currentOffset
            }
        }

        tableView.tableFooterView = footerView
        view.layoutIfNeeded()
    }
}

extension TableFooterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: dummyCellId) else {
            return UITableViewCell()
        }

        let people = people[indexPath.row]
        cell.textLabel?.text = people.name
        return cell
    }
}
