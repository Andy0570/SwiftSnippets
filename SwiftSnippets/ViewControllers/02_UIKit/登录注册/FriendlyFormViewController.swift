//
//  FriendlyFormViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/16.
//

import UIKit

/// 在 iOS 上制作用户友好表单的 5 个技巧:
/// 1.在文本输入框中，充分利用回车键的优势；
/// 2.使用 placeholder 告知用户；
/// 3.禁用更正和拼写检查；
/// 4.启用密码安全输入；
/// 5.表单验证和视觉提示；
///
/// 参考：<https://cocoacasts.com/five-simple-tips-to-make-user-friendly-forms-on-ios/>
class FriendlyFormViewController: UIViewController {
    // MARK: - Properties

    /// 垂直布局的堆栈视图
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()

    private lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.placeholder = "First Name"
        // 禁用更正和拼写检查
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()

    private lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.placeholder = "Last Name"
        // 禁用更正和拼写检查
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.placeholder = "Password"
        // 禁用更正和拼写检查
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        // 密码安全输入
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        // textField.addBottomBorder(borderColor: .separator)
        textField.delegate = self
        textField.placeholder = "Email"
        // 禁用更正和拼写检查
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        // 键盘类型设置为电子邮件地址
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var passwordValidationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        return label
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create an Account"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        setupSubviews()
    }

    private func setupSubviews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(firstNameTextField)
        stackView.addArrangedSubview(lastNameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(passwordValidationLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(saveButton)

        // Configure Password Validation Label
        passwordValidationLabel.isHidden = true

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            firstNameTextField.heightAnchor.constraint(equalToConstant: 44),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordValidationLabel.heightAnchor.constraint(equalToConstant: 44),
            emailTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Actions

    @objc func saveButtonTapped(_ sender: UIButton) {
        printLog("点击了提交按钮，验证表单，发送网络请求...")
    }

    // MARK: - Helper Methods

    private func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }

        if textField == passwordTextField {
            return (text.count >= 6, "Your password is too short.")
        }

        return (!text.isEmpty, "This field cannot be empty.")
    }
}

extension FriendlyFormViewController: UITextFieldDelegate {
    // 当用户点击右下角的回车键时，自动将下一个文本输入框作为第一响应者
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            // Validate Text Field
            let (valid, message) = validate(textField)
            if valid {
                emailTextField.becomeFirstResponder()
            }

            // Update Password Validation Label
            self.passwordValidationLabel.text = message

            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.25) {
                self.passwordValidationLabel.isHidden = valid
            }
        default:
            emailTextField.resignFirstResponder()
        }

        return true
    }
}
