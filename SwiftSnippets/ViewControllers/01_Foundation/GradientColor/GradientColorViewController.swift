//
//  GradientColorViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/3.
//

import UIKit

/**
 将渐变色应用于 UILabel

 要点：
 * 创建一个 UIStackView 子类作为容器视图，封装 UILabel

 参考：
 <https://nemecek.be/blog/143/always-correct-gradient-text-in-uikit>
 */
class GradientColorViewController: UIViewController {
    weak var gradientLabel1: GradientLabel!
    weak var gradientLabel2: GradientLabel!
    weak var gradientLabel3: GradientLabel!
    weak var gradientLabel4: GradientLabel!

    override func loadView() {
        super.loadView()

        // 初始化并添加 gradientLabel
        let gradientLabel1 = GradientLabel()
        gradientLabel1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradientLabel1)
        self.gradientLabel1 = gradientLabel1
        NSLayoutConstraint.activate([
            gradientLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gradientLabel1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gradientLabel1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        ])

        let gradientLabel2 = GradientLabel()
        gradientLabel2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradientLabel2)
        self.gradientLabel2 = gradientLabel2
        NSLayoutConstraint.activate([
            gradientLabel2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gradientLabel2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gradientLabel2.topAnchor.constraint(equalTo: gradientLabel1.bottomAnchor, constant: 20)
        ])

        let gradientLabel3 = GradientLabel()
        gradientLabel3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradientLabel3)
        self.gradientLabel3 = gradientLabel3
        NSLayoutConstraint.activate([
            gradientLabel3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gradientLabel3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gradientLabel3.topAnchor.constraint(equalTo: gradientLabel2.bottomAnchor, constant: 20)
        ])

        let gradientLabel4 = GradientLabel()
        gradientLabel4.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradientLabel4)
        self.gradientLabel4 = gradientLabel4
        NSLayoutConstraint.activate([
            gradientLabel4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gradientLabel4.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gradientLabel4.topAnchor.constraint(equalTo: gradientLabel3.bottomAnchor, constant: 20)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        // 配置 gradientLabel
        gradientLabel1.label.font = UIFont.systemFont(ofSize: 24)
        gradientLabel1.label.text = "Final solution example"
        gradientLabel1.label.textAlignment = .center

        gradientLabel2.label.font = UIFont.systemFont(ofSize: 48)
        gradientLabel2.label.text = "Works even with multi-line text thanks to the UIStackView which handles layout"
        gradientLabel2.label.textAlignment = .center
        gradientLabel2.label.numberOfLines = 0

        gradientLabel3.label.font = UIFont.systemFont(ofSize: 32)
        gradientLabel3.label.text = "Another Gradient text"
        gradientLabel3.label.textAlignment = .center

        gradientLabel4.label.font = UIFont.systemFont(ofSize: 24)
        gradientLabel4.label.text = "It is hard to come up with example text..."
        gradientLabel4.label.textAlignment = .center
        gradientLabel4.label.numberOfLines = 0
    }
}
