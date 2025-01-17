//
//  DownloadButton.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/16.
//

import UIKit

/// 自定义下载按钮
/// Reference: <https://nsscreencast.com/episodes/242-designing-a-custom-download-button-part-1>
final class DownloadButton: UIControl {
    lazy var downloadImage = UIImage.download
    lazy var completedImage = UIImage.checkmarks

    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.image = downloadImage
        addSubview(imageView)

        addTarget(self, action: #selector(addHighlight), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(removeHighlight), for: [.touchUpInside, .touchDragExit])
    }

    // MARK: - Actions

    @objc private func addHighlight() {
        backgroundColor = .red
    }

    @objc private func removeHighlight() {
        backgroundColor = .clear
    }
}
