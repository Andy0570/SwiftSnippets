//
//  CustomAlertHomeController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/6/30.
//

import UIKit

class CustomAlertHomeController: UIViewController {
    // MARK: - Controls
    private var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubview()
    }

    // MARK: - Actions

    @objc func actionOnSingleButtonAlert(_ sender: UIButton) {
        let customAlert = RTCustomAlert()
        customAlert.alertTitle = "Thank you"
        customAlert.alertMessage = "Your order successfully done."
        customAlert.alertTag = 1
        customAlert.statusImage = UIImage.init(named: "sheep")
        customAlert.show()
    }
}

extension CustomAlertHomeController {
    private func setupSubview() {
        navigationItem.title = "自定义 Alert View"
        view.backgroundColor = .systemBackground

        // button
        button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show Button Alert", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(actionOnSingleButtonAlert(_:)), for: .touchUpInside)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
