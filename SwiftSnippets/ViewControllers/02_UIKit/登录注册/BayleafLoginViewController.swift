//
//  BayleafLoginViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/19.
//

import UIKit

/**
 如何使用 Swift 在你的 iOS 应用程序中添加漂亮的 UITextField 动画
 Reference: <https://blog.devgenius.io/how-to-add-a-nice-uitextfield-animation-to-your-ios-app-using-swift-7aea90d120ad>
 */
class BayleafLoginViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameLine: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLine: UIView!
    @IBOutlet weak var signinButton: UIButton!

    lazy var textFields = [usernameTextField, passwordTextField]
    var placeholders = ["username", "password"]

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        for (index, textField) in textFields.enumerated() {
            textField?.attributedPlaceholder = NSAttributedString(string: placeholders[index], attributes: [.foregroundColor: UIColor.white])
            textField?.delegate = self
        }

        signinButton.layer.cornerRadius = signinButton.frame.height / 2
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Actions
    @IBAction func signInButtonTapped(_ sender: Any) {
        printLog("点击了登录按钮，验证表单，发送网络请求...")
    }

    @IBAction func signupButtonTapped(_ sender: Any) {
        printLog("点击了注册按钮，跳转到新用户注册页面...")
    }
}

extension BayleafLoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case usernameTextField:
            animate(line: usernameLine)
        case passwordTextField:
            animate(line: passwordLine)
        default:
            return
        }
    }

    private func animate(line: UIView) {
        line.alpha = 0.3
        UIView.animate(withDuration: 1.0) {
            line.alpha = 1.0
        }
    }
}
