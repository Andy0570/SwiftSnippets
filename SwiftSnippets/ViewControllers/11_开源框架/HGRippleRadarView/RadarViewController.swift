//
//  RadarViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/17.
//

import HGRippleRadarView

/// HGRippleRadarView 官方示例1
/// GitHub: <https://github.com/HamzaGhazouani/HGRippleRadarView>
final class RadarViewController: UIViewController {
    // MARK: - Properties

    private var timer: Timer?
    private var index = 0
    private var items: [Item] = []

    private lazy var radarView: RadarView = {
        let radarView = RadarView()
        radarView.translatesAutoresizingMaskIntoConstraints = false
        radarView.backgroundColor = UIColor(hex: "#454165")
        radarView.delegate = self
        return radarView
    }()

    // MARK: - View Life Cycle

    deinit {
        timer?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        setupSubview()

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(addItem), userInfo: nil, repeats: true)
    }

    private func setupSubview() {
        view.addSubview(radarView)
        NSLayoutConstraint.activate([
            radarView.topAnchor.constraint(equalTo: view.topAnchor),
            radarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            radarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            radarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc private func addItem() {
        if index > 3 {
            addMultipleItems()
            timer?.invalidate()
            return
        }

        let newItem = Item(uniqueKey: "item\(index)", value: "item\(index)")
        items.append(newItem)
        radarView.add(item: newItem)
        index += 1
    }

    private func addMultipleItems() {
        var tempItems: [Item] = []
        tempItems.reserveCapacity(3) // 预先分配数组容量
        for _ in 0 ..< 3 {
            let newItem = Item(uniqueKey: "item\(index)", value: "item\(index)")
            tempItems.append(newItem)
            index += 1
        }
        items.append(contentsOf: tempItems)
        radarView.add(items: tempItems)
    }

    @objc private func removeFirstItem() {
        guard let firstItem = items.first else {
            return
        }
        radarView.remove(item: firstItem)
    }
}

// MARK: - RadarViewDelegate

extension RadarViewController: RadarViewDelegate {
    func radarView(radarView: RadarView, didSelect item: Item) {
        printLog("选中了 item, key = \(item.uniqueKey)")
    }

    func radarView(radarView: RadarView, didDeselect item: Item) {
        printLog("取消选中了 item, key = \(item.uniqueKey)")
    }

    func radarView(radarView: RadarView, didDeselectAllItems lastSelectedItem: Item) {
        printLog("取消选中了所有 item！")
    }
}
