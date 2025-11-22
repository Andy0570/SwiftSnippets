//
//  FaveButtonViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/6.
//

import UIKit
import FaveButton

/// 点赞效果
///
/// FaveButton <https://github.com/janselv/fave-button>
/// 参考：<https://blog.csdn.net/guoyongming925/article/details/113258425?spm=1001.2014.3001.5501>
class FaveButtonViewController: UIViewController {
    @IBOutlet private weak var heartButton: FaveButton!
    @IBOutlet private weak var loveButton: FaveButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        // optional, set default selected fave-buttons with initial
        // startup animation disabled
        self.heartButton.setSelected(selected: true, animated: false)

        self.loveButton.setSelected(selected: true, animated: false)
        self.loveButton.setSelected(selected: false, animated: false)

        // ----------------------------------
        // 用 Swift 实现 Instagram 的“点赞”动画
        let heartButton = HeartButton(frame: .zero)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        heartButton.addTarget(self, action: #selector(handleHeartButtonTap(_:)), for: .touchUpInside)
        view.addSubview(heartButton)
        NSLayoutConstraint.activate([
            heartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            heartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            heartButton.widthAnchor.constraint(equalToConstant: 50),
            heartButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // ----------------------------------
        // 带有“礼花”动画的点赞按钮
        let toggleButton = SHToggleButton()
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.defaultImage = UIImage(named: "like_normal")
        toggleButton.selectedImage = UIImage(named: "like_fill")
        toggleButton.animatedImage = UIImage(named: "like_fill")
        view.addSubview(toggleButton)
        NSLayoutConstraint.activate([
            toggleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            toggleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            toggleButton.widthAnchor.constraint(equalToConstant: 48),
            toggleButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    // MARK: - Action

    @objc private func handleHeartButtonTap(_ sender: UIButton) {
        guard let button = sender as? HeartButton else {
            return
        }
        button.flipLikedState()

        printLog("用 Swift 实现 Instagram 的点赞动画")
    }
}

extension FaveButtonViewController: FaveButtonDelegate {
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        printLog("Button Tag: \(faveButton.tag), selected: \(selected)")
    }

    // 自定义动画中 Dot（点） 的颜色
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]? {
        if faveButton === heartButton || faveButton === loveButton {
            return [
                DotColors(first: UIColor(hexString: "0x7DC2F4").require(), second: UIColor(hexString: "0xE2264D").require()),
                DotColors(first: UIColor(hexString: "0xF8CC61").require(), second: UIColor(hexString: "0x9BDFBA").require()),
                DotColors(first: UIColor(hexString: "0xAF90F4").require(), second: UIColor(hexString: "0x90D1F9").require()),
                DotColors(first: UIColor(hexString: "0xE9A966").require(), second: UIColor(hexString: "0xF8C852").require()),
                DotColors(first: UIColor(hexString: "0xF68FA7").require(), second: UIColor(hexString: "0xF6A2B8").require())
            ]
        }
        return nil
    }
}
