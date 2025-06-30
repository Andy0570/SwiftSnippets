//
//  RTCustomAlert.swift
//  RTCustomAlert
//
//  Created by huqilin on 2025/6/30.
//

import UIKit

/// 在 Swift 中创建自定义 Alert 控制器
///
/// Reference: <https://rohittamkhane.medium.com/create-a-custom-alert-controller-in-swift-ef5d715839f5>
class RTCustomAlert: UIViewController {
    // MARK: - Controls

    private var alertView: UIView!
    private var titleLabel: UILabel!
    private var statusImageView: UIImageView!
    private var messageLabel: UILabel!
    private var okButton: UIButton!
    private var cancelButton: UIButton!

    var alertTitle = ""
    var alertMessage = ""
    var okButtonTitle = "Ok"
    var cancelButtonTitle = "Cancel"
    var alertTag = 0
    var statusImage = UIImage.init(named: "smiley")
    var isCancelButtonHidden = false

    var completionBlock: (() -> Void)?
    var cancelBlock: (() -> Void)?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func show() {
        // Get the current scene's  key window
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(self, animated: false) {
                UIView.animate(withDuration: 0.2) {
                    self.view.alpha = 1.0
                }
            }
        }

//        if #available(iOS 13, *) {
//            UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true)
//        } else {
//            UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true)
//        }
    }

    // MARK: - Actions

    @objc func actionOnOkButton(_ button: UIButton) {
        completionBlock?()
        self.dismiss(animated: true)
    }

    @objc func actionOnCancelButton(_ button: UIButton) {
        cancelBlock?()
        self.dismiss(animated: true)
    }
}

extension RTCustomAlert {
    private func setupView() {
        // view.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)

        alertView = UIView(frame: .zero)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.backgroundColor = UIColor.systemBackground
        view.addSubview(alertView)

        statusImageView = UIImageView(frame: .zero)
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.image = statusImage
        alertView.addSubview(statusImageView)

        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.textColor = UIColor.label
        titleLabel.text = alertTitle
        alertView.addSubview(titleLabel)

        messageLabel = UILabel(frame: .zero)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
        messageLabel.textColor = UIColor.secondaryLabel
        messageLabel.text = alertMessage
        alertView.addSubview(messageLabel)

        okButton = UIButton(type: .custom)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.setTitle(okButtonTitle, for: .normal)
        okButton.setTitleColor(UIColor.systemBlue, for: .normal)
        okButton.addTarget(self, action: #selector(actionOnOkButton(_:)), for: .touchUpInside)
        alertView.addSubview(okButton)

        NSLayoutConstraint.activate([
            alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            statusImageView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10),
            statusImageView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: 24),
            statusImageView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.topAnchor.constraint(equalTo: statusImageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),

            okButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            okButton.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            okButton.heightAnchor.constraint(equalToConstant: 44),
            okButton.widthAnchor.constraint(equalToConstant: 100),
            okButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 10)
        ])
    }
}
