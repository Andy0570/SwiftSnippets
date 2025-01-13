//
//  CartViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/13.
//

import UIKit

final class CartViewController: UIViewController {
    private var bookListController: BookListViewController?

    private lazy var panelView: CartPanelView = {
        let view = CartPanelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 10
        return view
    }()

    private var books: [Book]

    init(books: [Book]) {
        self.books = books

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Cart"
        isModalInPresentation = true

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = .systemBackground

        navigationItem.largeTitleDisplayMode = .never

        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in
            self.dismiss(animated: true)
        })

        view.backgroundColor = .systemBackground

        view.addSubview(panelView)
        NSLayoutConstraint.activate([
            panelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            panelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            panelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            panelView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 1 / 3)
        ])

        bookListController = BookListViewController(books: books, config: BookListViewController.Configuration(showAddButtons: false))
        if let bookListController {
            addChildController(bookListController, bottomAnchor: panelView.topAnchor)
        }
    }
}
