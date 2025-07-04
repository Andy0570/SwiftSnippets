//
//  EmptyView.swift
//  SeaTao
//
//  Created by Qilin Hu on 2022/7/7.
//

import UIKit

/// Emtpy View: UIImageView + UILabel
///
/// 使用示例：
/// `EmptyView(image: UIImage(named: "placeholder_8").require(), description: "请添加收货地址～")`
/// `EmptyView(image: UIImage(named: "placeholder_3").require(), description: "你还没有拉黑任何人")`
final class EmptyView: UIView {
    // MARK: - Controls
    private var imageView: UIImageView!
    private var titleLabel: UILabel!

    // MARK: - Private
    private let image: UIImage
    private let emptyDescription: String

    // MARK: - Initialize
    init(image: UIImage, description: String) {
        self.image = image
        self.emptyDescription = description
        super.init(frame: .zero)
        makeUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeUI() {
        backgroundColor = .systemBackground

        // imageView
        imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)

        // titleLabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = emptyDescription
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingTail
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 137),
            imageView.heightAnchor.constraint(equalToConstant: 124),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
