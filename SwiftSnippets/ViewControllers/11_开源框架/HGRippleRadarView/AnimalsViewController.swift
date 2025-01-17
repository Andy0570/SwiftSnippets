//
//  AnimalsViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/17.
//

import HGRippleRadarView

// FIXME: 本示例的动画存在意外的 Bug

/// HGRippleRadarView 官方示例3
/// GitHub: <https://github.com/HamzaGhazouani/HGRippleRadarView>
final class AnimalsViewController: UIViewController {
    // MARK: - Properties

    var bottomLayoutConstraint: NSLayoutConstraint!

    private lazy var radarView: RadarView = {
        let radarView = RadarView()
        radarView.translatesAutoresizingMaskIntoConstraints = false
        radarView.backgroundColor = UIColor.white
        radarView.diskColor = UIColor(hex: "#FF004F")
        radarView.circleOffColor = UIColor(hex: "#23FF83")
        radarView.circleOnColor = UIColor(hex: "#FF004F")

        radarView.dataSource = self
        radarView.delegate = self

        return radarView
    }()

    private lazy var selectedAnimalView: AnimalView = {
        let animalView = AnimalView()
        animalView.translatesAutoresizingMaskIntoConstraints = false
        animalView.layer.shadowRadius = 5.0
        animalView.layer.shadowOpacity = 0.2
        animalView.masksToBounds = false
        return animalView
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        setupSubview()

        // 一次性在雷达视图上添加多个元素
        let animals = [
            Animal(title: "Bird", color: .lightBlue, imageName: "bird"),
            Animal(title: "Cat", color: .lightGray, imageName: "cat"),
            Animal(title: "Cattle", color: .lightGray, imageName: "catttle"),
            Animal(title: "Dog", color: .darkYellow, imageName: "dog"),
            Animal(title: "Rat", color: .lightBlack, imageName: "rat")
        ]
        let items = animals.map { Item(uniqueKey: $0.title, value: $0) }
        radarView.add(items: items)
    }

    private func setupSubview() {
        view.addSubview(radarView)
        view.addSubview(selectedAnimalView)

        bottomLayoutConstraint = selectedAnimalView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 250)

        NSLayoutConstraint.activate([
            radarView.topAnchor.constraint(equalTo: view.topAnchor),
            radarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160),
            radarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            radarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            selectedAnimalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectedAnimalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectedAnimalView.heightAnchor.constraint(equalToConstant: 160),
            bottomLayoutConstraint
        ])
    }

    // 放大动画
    private func enlarge(view: UIView?) {
        let animation = Animation.transform(from: 1.0, to: 1.5)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        view?.layer.add(animation, forKey: "transform")
    }

    // 缩小动画
    private func reduce(view: UIView?) {
        let animation = Animation.transform(from: 1.5, to: 1.0)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        view?.layer.add(animation, forKey: "transform")
    }

    private func showView(for animal: Animal) {
        selectedAnimalView.tintColor = animal.color
        selectedAnimalView.titleLabel.text = animal.title
        if let image = UIImage(named: animal.imageName) {
            selectedAnimalView.imageView.image = image
        }

        NSLayoutConstraint.deactivate([bottomLayoutConstraint])
        bottomLayoutConstraint.constant = 0
        NSLayoutConstraint.activate([bottomLayoutConstraint])

        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }

    private func hideAnimalView(completion: (() -> Void)? = nil) {
        NSLayoutConstraint.deactivate([bottomLayoutConstraint])
        bottomLayoutConstraint.constant = 250
        NSLayoutConstraint.activate([bottomLayoutConstraint])

        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion?()
        }
    }
}

// MARK: - RadarViewDataSource

extension AnimalsViewController: RadarViewDataSource {
    func radarView(radarView: HGRippleRadarView.RadarView, viewFor item: HGRippleRadarView.Item, preferredSize: CGSize) -> UIView {
        let animal = item.value as? Animal
        let frame = CGRect(x: 0, y: 0, width: preferredSize.width, height: preferredSize.height)
        let imageView = UIImageView(frame: frame)

        guard let imageName = animal?.imageName else {
            return imageView
        }

        imageView.image = UIImage(named: imageName)
        return imageView
    }
}

// MARK: - RadarViewDelegate

extension AnimalsViewController: RadarViewDelegate {
    func radarView(radarView: HGRippleRadarView.RadarView, didSelect item: HGRippleRadarView.Item) {
        printLog("选中了 item, key = \(item.uniqueKey)")

        let view = radarView.view(for: item)
        enlarge(view: view)

        guard let animal = item.value as? Animal else {
            return
        }

        // 先隐藏旧视图，再显示新视图
        if bottomLayoutConstraint.constant == 0 {
            hideAnimalView {
                self.showView(for: animal)
            }
        } else {
            showView(for: animal)
        }
    }

    func radarView(radarView: HGRippleRadarView.RadarView, didDeselect item: HGRippleRadarView.Item) {
        printLog("取消选中了 item, key = \(item.uniqueKey)")

        let view = radarView.view(for: item)
        reduce(view: view)
    }

    func radarView(radarView: HGRippleRadarView.RadarView, didDeselectAllItems lastSelectedItem: HGRippleRadarView.Item) {
        printLog("取消选中了所有 item！")

        let view = radarView.view(for: lastSelectedItem)
        reduce(view: view)
        hideAnimalView()
    }
}
