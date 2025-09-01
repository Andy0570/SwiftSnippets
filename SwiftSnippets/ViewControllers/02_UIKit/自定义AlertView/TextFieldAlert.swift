//
//  TextFieldAlert.swift
//  Demo
//
//  Created by huqilin on 2025/9/1.
//

import UIKit

/// 输入框弹窗
final class TextFieldAlert: BaseAlertViewController {
    // MARK: - Controls
    private var alertContainerView: UIView!
    private var titleLabel: UILabel!

    private var verticalStackView: UIStackView!
    private var inputContainerView: UIView!
    private var textField: UITextField!
    private var unitLabel: UILabel!
    private var footerLabel: UILabel!

    private var bottomContainerView: UIView!
    private var cancelButton: UIButton!
    private var confirmButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        textField.becomeFirstResponder()
    }

    // MARK: - Callbacks
    private var onConfirm: ((String) -> Void)?

    // MARK: - Actions
    @objc private func cancleButtonPressed() {
        dismiss(animated: true)
    }

    @objc private func confirmButtonPressed() {
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.onConfirm?(self.textField.text.require(hint: "Input value should not be nil."))
        }
    }
}

// MARK: - 配置方法
extension TextFieldAlert {
    @objc func configure(
        title: String,
        content: String,
        unit: String,
        keyboardType: UIKeyboardType = .default,
        onConfirm: ((String) -> Void)?
    ) {
        titleLabel.text = title
        textField.text = content
        unitLabel.text = unit
        textField.keyboardType = keyboardType
        self.onConfirm = onConfirm
    }
}

extension TextFieldAlert: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

/**
 视图层次结构:
 
 UIView (alertContainerView)
  ├─ UILabel（titleLabel）
  ├─ UIStackView（verticalStackView）
  │   ├─ UIView（inputContainerView）
  │   │   ├─ UITextField（textField）
  │   │   └─ UILabel（unitLabel）
  │   └─ UILabel（footerLabel）
  └─ UIView（bottomContainerView）
      ├─ UIButton（cancelButton）
      └─ UIButton（confirmButton）
 */
extension TextFieldAlert {
    private func setupView() {
        // alertContainerView
        alertContainerView = UIView(frame: .zero)
        alertContainerView.translatesAutoresizingMaskIntoConstraints = false
        alertContainerView.backgroundColor = UIColor(hex: "#232326")
        alertContainerView.layer.cornerRadius = 10.0
        alertContainerView.layer.masksToBounds = true
        view.addSubview(alertContainerView)

        // titleLabel
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor(hex: "#E9EBF0")
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.text = "Test Title"
        alertContainerView.addSubview(titleLabel)

        // verticalStackView
        verticalStackView = UIStackView(frame: .zero)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .equalSpacing
        verticalStackView.spacing = 5
        alertContainerView.addSubview(verticalStackView)

        // inputContainerView
        inputContainerView = UIView(frame: .zero)
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.backgroundColor = UIColor(hex: 0x2C3035)
        inputContainerView.layer.masksToBounds = true
        inputContainerView.layer.cornerRadius = 10.0
        verticalStackView.addArrangedSubview(inputContainerView)

        // textField
        textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.delegate = self
        inputContainerView.addSubview(textField)

        // unitLabel
        unitLabel = UILabel(frame: .zero)
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.backgroundColor = .clear
        unitLabel.textColor = UIColor(hex: "#666A76")
        unitLabel.textAlignment = .center
        unitLabel.font = .systemFont(ofSize: 17, weight: .regular)
        inputContainerView.addSubview(unitLabel)

        // 让 unitLabel 保持固有内容大小
        unitLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        unitLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        // footerLabel
        footerLabel = UILabel(frame: .zero)
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        footerLabel.text = "micro_storage_export_power_limit_tips".localized()
        footerLabel.textColor = UIColor(hex: "#FA4D56")
        footerLabel.font = .systemFont(ofSize: 13.0, weight: .regular)
        footerLabel.numberOfLines = 0
        footerLabel.isHidden = true
        verticalStackView.addArrangedSubview(footerLabel)

        // bottomContainerView
        bottomContainerView = UIView(frame: .zero)
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.backgroundColor = UIColor(red: 135 / 255.0, green: 141 / 255.0, blue: 150 / 255.0, alpha: 0.32)
        alertContainerView.addSubview(bottomContainerView)

        // cancelButton
        cancelButton = UIButton(type: .custom)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("cancel".localized(), for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.setTitleColor(UIColor.white.darken(by: 0.1), for: .highlighted)
        cancelButton.setBackgroundColor(color: UIColor(hex: "#232326"), forState: .normal)
        cancelButton.addTarget(self, action: #selector(cancleButtonPressed), for: .touchUpInside)
        bottomContainerView.addSubview(cancelButton)

        // confirmButton
        confirmButton = UIButton(type: .custom)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitle("confirm".localized(), for: .normal)
        confirmButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        confirmButton.setTitleColor(.systemBlue, for: .normal)
        confirmButton.setTitleColor(.systemBlue.darken(by: 0.1), for: .highlighted)
        confirmButton.setBackgroundColor(color: UIColor(hex: "#232326"), forState: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
        bottomContainerView.addSubview(confirmButton)

        NSLayoutConstraint.activate([
            alertContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            alertContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            titleLabel.topAnchor.constraint(equalTo: alertContainerView.topAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.centerXAnchor.constraint(equalTo: alertContainerView.centerXAnchor),

            verticalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            verticalStackView.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -16),

            inputContainerView.heightAnchor.constraint(equalToConstant: 44),
            textField.topAnchor.constraint(equalTo: inputContainerView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 16),
            textField.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor),
            unitLabel.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 4),
            unitLabel.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -16),
            unitLabel.centerYAnchor.constraint(equalTo: textField.centerYAnchor),

            bottomContainerView.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 16),
            bottomContainerView.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: alertContainerView.bottomAnchor),
            bottomContainerView.heightAnchor.constraint(equalToConstant: 54),

            cancelButton.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 1),
            cancelButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor),
            cancelButton.widthAnchor.constraint(equalTo: confirmButton.widthAnchor),

            confirmButton.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 1),
            confirmButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 1),
            confirmButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor)
        ])
    }
}
