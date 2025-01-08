//
//  HeartButton.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/5.
//

import UIKit

/// 用 Swift 实现 Instagram 的“点赞”动画
/// 参考：<https://github.com/4taras4/Heart-Button-Demo>
class HeartButton: UIButton {
    private var isLiked = false

    private let unlikedImage = UIImage(named: "heart_empty")
    private let likedImage = UIImage(named: "heart_filled")

    private let unlikedScale: CGFloat = 0.7
    private let likedScale: CGFloat = 1.3

    override init(frame: CGRect) {
        super.init(frame: frame)

        setImage(unlikedImage, for: .normal)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func flipLikedState() {
        isLiked.toggle()
        animate()
    }

    private func animate() {
        UIView.animate(withDuration: 0.1) {
            let newImage = self.isLiked ? self.likedImage : self.unlikedImage
            let newScale = self.isLiked ? self.likedScale : self.unlikedScale
            self.transform = self.transform.scaledBy(x: newScale, y: newScale)
            self.setImage(newImage, for: .normal)
        } completion: { _ in
            self.transform = CGAffineTransform.identity
        }
    }
}
