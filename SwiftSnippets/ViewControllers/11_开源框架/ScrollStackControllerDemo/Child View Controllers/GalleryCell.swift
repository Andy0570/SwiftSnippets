//
//  GalleryCell.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/11.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = UIColor.secondarySystemBackground
        return view
    }()

    private var dataTask: URLSessionTask?

    var url: URL? {
        didSet {
            dataTask?.cancel()

            guard let imageURL = url else {
                self.imageView.image = nil
                return
            }

            // 发起网络请求，获取 data 数据
            dataTask = URLSession.shared.dataTask(with: imageURL, completionHandler: { data, _, _ in
                // data -> UIImage
                let image = (data != nil ? UIImage(data: data!) : nil)
                // 切换到主线程，更新UI
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            })
            dataTask?.resume()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.url = nil
    }
}
