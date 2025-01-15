//
//  HomeNavigationController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/12/6.
//

import UIKit

class HomeNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    func initialize() {
        // 始终显示大导航栏标题
        // navigationBar.prefersLargeTitles = true
        // navigationItem.largeTitleDisplayMode = .never

        // custom tint color
        navigationBar.tintColor = .systemGray
        // custom background color
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .systemBackground
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}
