//
//  WelcomeVC.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/11.
//

import UIKit

class WelcomeVC: UIViewController {
    // MARK: - Controls
    private var titleLabel: UILabel!
    private var imageView: UIImageView!
    private var contentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        view.backgroundColor = UIColor.systemBackground

        // titleLabel
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .natural
        titleLabel.textColor = UIColor.label
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.text = "Welcome to Hotel"
        view.addSubview(titleLabel)

        // imageView
        imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "hotel")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        // contentLabel
        contentLabel = UILabel(frame: .zero)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.textAlignment = .natural
        contentLabel.textColor = UIColor.secondaryLabel
        contentLabel.font = .systemFont(ofSize: 12, weight: .regular)
        contentLabel.text = "Reminiscent of a 16th century Italian Palace, Palazzo Versace Dubai features a high ceiling entrance, landscaped gardens, and a range of well-crafted Italian furnishings.\nSet in the heart of the Culture Village, less than 15 minutes away from Dubai International Airport and 8 minutes away from Burj Khalifa and Downtown Dubai, Palazzo Versace Dubai is conveniently located along the shores of the historic Dubai Creek."
        contentLabel.numberOfLines = 0
        view.addSubview(contentLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 29),

            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 273),
            imageView.heightAnchor.constraint(equalToConstant: 146),

            contentLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -27)
        ])
    }
}

extension WelcomeVC: FoxScrollStackContainableController {
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        // let size = CGSize(width: stackView.bounds.size.width, height: 9000)
        // let best = self.view.systemLayoutSizeFitting(size, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        // return best.height
        return .fitLayoutForAxis
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}

/// 自定义显示/隐藏动画
extension WelcomeVC: FoxScrollStackRowAnimatable {
    public var animationInfo: FoxScrollStackAnimationInfo {
        return FoxScrollStackAnimationInfo(duration: 1.0, delay: 0, springDamping: 0.8)
    }

    func animateTransition(toHide: Bool) {
        if toHide {
            self.view.transform = CGAffineTransform(translationX: -100, y: 0)
            self.view.alpha = 0
        } else {
            self.view.transform = .identity
            self.view.alpha = 1
        }
    }

    func willBeginAnimationTransition(toHide: Bool) {
        if !toHide {
            self.view.transform = CGAffineTransform(translationX: -100, y: 0)
            self.view.alpha = 0
        }
    }
}
