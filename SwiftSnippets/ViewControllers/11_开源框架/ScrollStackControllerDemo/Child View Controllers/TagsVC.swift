//
//  TagsVC.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/11.
//

import UIKit

protocol TagsVCProtocol: AnyObject {
    func toggleTags()
}

class TagsVC: UIViewController {
    // MARK: - Controls
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var contentLabel: UILabel!
    private var collectionView: UICollectionView!
    private var toggleTagsButton: UIButton!

    public weak var delegate: TagsVCProtocol?

    private var tags: [String] = [
        "swimming pool",
        "kitchen",
        "terrace",
        "bathtub",
        "A/C",
        "parking",
        "pet friendly",
        "relax spa",
        "private bathroom",
        "cafe"
    ]

    public var isExpanded = false {
        didSet {
            if isExpanded {
                collectionView.height(constant: collectionView.contentSize.height)
            }
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        collectionView.reloadData()
        updateUI()
    }

    private func updateUI() {
        toggleTagsButton.setTitle( (isExpanded ? "Hide Tags" : "Show Tags"), for: .normal)
    }

    private func setupView() {
        view.backgroundColor = UIColor.systemBackground

        // titleLabel
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .natural
        titleLabel.textColor = UIColor.label
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.text = "Tags"
        view.addSubview(titleLabel)

        // subTitleLabel
        subTitleLabel = UILabel(frame: .zero)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.textAlignment = .natural
        subTitleLabel.textColor = UIColor.secondaryLabel
        subTitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subTitleLabel.text = "Collpase/Expand UIViewController"
        view.addSubview(subTitleLabel)

        // contentLabel
        contentLabel = UILabel(frame: .zero)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.textAlignment = .natural
        contentLabel.textColor = UIColor.secondaryLabel
        contentLabel.font = .systemFont(ofSize: 12, weight: .regular)
        contentLabel.numberOfLines = 0
        contentLabel.text = "The list of tags identify the main features of the hotel and allows you have an overlook of the structure."
        view.addSubview(contentLabel)

        toggleTagsButton = UIButton(type: .custom)
        toggleTagsButton.translatesAutoresizingMaskIntoConstraints = false
        toggleTagsButton.setTitle("Show Tags", for: .normal)
        toggleTagsButton.setBackgroundColor(color: UIColor.purple, forState: .normal)
        toggleTagsButton.addTarget(self, action: #selector(toggleTagsButtonDidTapped(_:)), for: .touchUpInside)
        view.addSubview(toggleTagsButton)

        // collectionView
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical // 水平方向布局
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.itemSize = CGSize(width: 127, height: 39)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.isScrollEnabled = false
        collectionView.dragInteractionEnabled = true
        collectionView.dataSource = self

        collectionView.register(TagsCell.self, forCellWithReuseIdentifier: TagsCell.reuseIdentifier)

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            contentLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            toggleTagsButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10),
            toggleTagsButton.centerXAnchor.constraint(equalTo: contentLabel.centerXAnchor),
            // toggleTagsButton.heightAnchor.constraint(equalToConstant: 20),

            collectionView.topAnchor.constraint(equalTo: toggleTagsButton.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Actions

    @objc private func toggleTagsButtonDidTapped(_ sender: UIButton) {
        delegate?.toggleTags()
    }
}

extension TagsVC: FoxScrollStackContainableController {
    // 可折叠/展开的行
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return (isExpanded == false ? .fixed(150) : .fixed(150 + collectionView.contentSize.height + 20))
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}

extension TagsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagsCell.reuseIdentifier, for: indexPath) as? TagsCell else {
            fatalError("Unable to Dequeue Cell: 'TagsCell'")
        }
        cell.title = tags[indexPath.row]
        return cell
    }
}
