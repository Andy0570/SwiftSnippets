//
//  BaseAlertViewController.swift
//  Demo
//
//  Created by huqilin on 2025/7/1.
//

import UIKit

/// 在 Swift 中创建自定义 Alert 控制器
///
/// Reference: <https://rohittamkhane.medium.com/create-a-custom-alert-controller-in-swift-ef5d715839f5>
class BaseAlertViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }

    @objc func show() {
        if let topViewController = UIApplication.topViewController() {
            topViewController.present(self, animated: true)
        }
    }

    @objc func hide() {
        dismiss(animated: true)
    }
}
