//
//  DRHTextFieldViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/19.
//

import UIKit

class DRHTextFieldViewController: UIViewController {
    private lazy var textField: CharacterCountTextField = {
        let textField = CharacterCountTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.lengthLimit = 10
        textField.placeholder = "Nickname"
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        setupSubview()
    }

    private func setupSubview() {
        view.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.widthAnchor.constraint(equalToConstant: 200),
            textField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
