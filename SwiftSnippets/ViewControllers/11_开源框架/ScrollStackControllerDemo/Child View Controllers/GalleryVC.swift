//
//  GalleryVC.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/10.
//

import UIKit

class GalleryVC: UIViewController {
    // MARK: - Controls
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!

    public var urls: [URL] = [
        URL(string: "https://gfs8.gomein.net.cn/T1QtA_BXdT1RCvBVdK.jpg")!,
        URL(string: "https://gfs9.gomein.net.cn/T1__ZvB7Aj1RCvBVdK.jpg")!,
        URL(string: "https://gfs9.gomein.net.cn/T1__ZvB7Aj1RCvBVdK.jpg")!,
        URL(string: "https://gfs5.gomein.net.cn/T1SZ__B5VT1RCvBVdK.jpg")!
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }

    private func reloadData() {
        pageControl.numberOfPages = urls.count
        collectionView.reloadData()
    }


    private func setupView() {
        view.backgroundColor = UIColor.systemBackground

        // titleLabel
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .natural
        titleLabel.textColor = UIColor.label
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.text = "Gallery"
        view.addSubview(titleLabel)

        // subTitleLabel
        subTitleLabel = UILabel(frame: .zero)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.textAlignment = .natural
        subTitleLabel.textColor = UIColor.secondaryLabel
        subTitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subTitleLabel.text = "Fixed Size Controller"
        view.addSubview(subTitleLabel)

        // collectionView
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal // 水平方向布局
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true // 分页显示
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dragInteractionEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.reuseIdentifier)
        view.addSubview(collectionView)

        // pageControl
        pageControl = UIPageControl(frame: .zero)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.tintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.green
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 29),

            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
}

extension GalleryVC: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(300)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}

extension GalleryVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.reuseIdentifier, for: indexPath) as? GalleryCell else {
            fatalError("Unable to Dequeue Cell: 'GalleryCell'")
        }
        cell.url = urls[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 310, height: collectionView.bounds.size.height) // fix here
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
    }
}
