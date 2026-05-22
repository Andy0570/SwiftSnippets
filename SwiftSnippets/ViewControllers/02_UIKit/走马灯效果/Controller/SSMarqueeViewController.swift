//
//  SSMarqueeViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/29.
//

import UIKit

/// 走马灯效果
final class SSMarqueeViewController: UIViewController {
    // MARK: - Controls
    private let stackController = FoxScrollStackViewController()
    private var stackView: FoxScrollStack {
        return stackController.scrollStack
    }

    private let marquee1VC = SSMarquee1Controller()
    private let marquee2VC = SSMarquee2Controller()
    private let marquee3VC = SSMarquee3Controller()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        let rows = [marquee1VC, marquee2VC, marquee3VC]
        stackView.addRows(controllers: rows)
    }
}

// MARK: - Private
extension SSMarqueeViewController {
    private func setupView() {
        title = "走马灯效果"
        view.backgroundColor = .systemBackground

        stackView.backgroundColor = .systemBackground
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
