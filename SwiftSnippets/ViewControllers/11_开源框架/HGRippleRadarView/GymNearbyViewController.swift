//
//  GymNearbyViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/17.
//

import HGRippleRadarView

/// HGRippleRadarView 官方示例2 - 查找附近的健身房
/// GitHub: <https://github.com/HamzaGhazouani/HGRippleRadarView>
final class GymNearbyViewController: UIViewController {
    // MARK: - Properties

    private lazy var radarView: RadarView = {
        let radarView = RadarView()
        radarView.translatesAutoresizingMaskIntoConstraints = false
        radarView.backgroundColor = UIColor.white
        radarView.diskRadius = 20.0
        radarView.diskColor = UIColor(hex: "#656EF9")
        radarView.numberOfCircles = 0
        return radarView
    }()

    private lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.location
        return imageView
    }()

    /// 垂直布局的堆栈视图
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 15
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.text = "Gym Nearby"
        return label
    }()

    private lazy var subTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        label.text = "To help you find nearby gym and coaches, we need to know your location."
        return label
    }()

    private lazy var enableLocationButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .medium
        config.cornerStyle = .medium

        config.image = UIImage(systemName: "location.fill")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        config.imagePlacement = .leading
        config.imagePadding = 5

        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
            return outgoing
        }

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.setTitle("Enable Location", for: .normal)

        button.addAction(
            UIAction { _ in
                // TODO: 使用 SPPermissions/LocationWhenInUse 发起请求
                printLog("弹窗发起请求，开启系统定位权限！")
            }, for: .touchUpInside
        )
        return button
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        setupSubview()
    }

    private func setupSubview() {
        view.addSubview(radarView)
        radarView.addSubview(locationImageView)

        radarView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        stackView.addArrangedSubview(enableLocationButton)

        NSLayoutConstraint.activate([
            radarView.topAnchor.constraint(equalTo: view.topAnchor),
            radarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            radarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            radarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            locationImageView.centerXAnchor.constraint(equalTo: radarView.centerXAnchor),
            locationImageView.centerYAnchor.constraint(equalTo: radarView.centerYAnchor),
            locationImageView.widthAnchor.constraint(equalToConstant: 40),
            locationImageView.heightAnchor.constraint(equalToConstant: 40),

            stackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
}
