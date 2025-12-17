//
//  SSButtonDemoViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/17.
//

import UIKit
import SnapKit

/// iOS 15 中的 UIButton 新特性
/// 参考
/// * <https://www.notion.so/andy0570/iOS15-ab0747b1e9f04b0fa6679427340988e1?pvs=4>
final class SSButtonDemoViewController: UIViewController {
    // MARK: - Controls
    private let stackController = FoxScrollStackViewController()
    private var stackView: FoxScrollStack {
        return stackController.scrollStack
    }

    private let button1VC = SSButton1ViewController()
    private let button2VC = SSButton2ViewController()
    private let button3VC = SSButton3ViewController()
    private let button4VC = SSButton4ViewController()
    private let button5VC = SSButton5ViewController()
    private let button6VC = SSButton6ViewController()
    private let button7VC = SSButton7ViewController()
    private let button8VC = SSButton8ViewController()
    private let button9VC = SSButton9ViewController()
    private let button10VC = SSButton10ViewController()
    private let button11VC = SSButton11ViewController()
    private let button12VC = SSButton12ViewController()
    private let button13VC = SSButton13ViewController()
    private let button14VC = SSButton14ViewController()
    private let button15VC = SSButton15ViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private
extension SSButtonDemoViewController {
    private func setupView() {
        title = "Button Demo"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        view.backgroundColor = .systemBackground

        stackView.backgroundColor = .systemBackground
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        let rows = [
            button1VC, button2VC, button3VC, button4VC, button5VC, button6VC,
            button7VC, button8VC, button9VC, button10VC, button11VC, button12VC,
            button13VC, button14VC, button15VC
        ]
        stackView.addRows(controllers: rows)

        stackView.hideSeparators = false
    }
}
