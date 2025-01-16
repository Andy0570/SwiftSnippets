//
//  FlowersViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/16.
//

import UIKit

/// UIProgressView 使用示例
/// 参考：<https://www.kodeco.com/25358187-spinner-and-progress-bar-in-swift-getting-started>
class FlowersViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var loadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 6
        return view
    }()

    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()

    private var observation: NSKeyValueObservation?

    deinit {
        observation?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        fetchRedDelightFlowers()
    }

    private func fetchRedDelightFlowers() {
        let url = URL(string: "https://koenig-media.raywenderlich.com/uploads/2021/06/e96af3567bb3443debc03c198d831eb2.jpeg")
        guard let url else {
            return
        }

        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: url) { [weak self] data, _, _ in
            guard let self, let data else {
                return
            }

            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
                self.loadingView.isHidden = true // 加载完成后隐藏视图
            }
        }

        // 监控网络请求的变化，更新进度条
        observation = task.progress.observe(\.fractionCompleted, changeHandler: { progress, _ in
            DispatchQueue.main.async {
                self.progressView.progress = Float(progress.completedUnitCount)
            }
        })

        task.resume()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(imageView)
        view.addSubview(loadingView)
        loadingView.addSubview(progressView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 240),
            loadingView.heightAnchor.constraint(equalToConstant: 124),

            progressView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            progressView.widthAnchor.constraint(equalToConstant: 150),
            progressView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
}
