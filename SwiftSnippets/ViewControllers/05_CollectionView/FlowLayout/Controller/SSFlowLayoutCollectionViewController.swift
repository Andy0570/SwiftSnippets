//
//  SSFlowLayoutCollectionViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/23.
//

import UIKit

/// 集合视图 Flow Layout 流式布局
final class SSFlowLayoutCollectionViewController: UIViewController {
    // MARK: - Type Aliases
    private typealias DataSource = UICollectionViewDiffableDataSource<SSFlowLayoutSection, SSFlowLayoutItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SSFlowLayoutSection, SSFlowLayoutItem>

    // MARK: - Controls
    private var topTitleLabel: UILabel!
    private var topCollectionView: UICollectionView!
    private var bottomTitleLabel: UILabel!
    private var segmentControl: UISegmentedControl!
    private var bottomCollectionView: UICollectionView!

    // MARK: - Properties
    private var legendViewModels: [SSFlowLayoutViewModel] = []
    private lazy var topDataSource = makeDataSource(for: topCollectionView)
    private lazy var bottomDataSource = makeDataSource(for: bottomCollectionView)

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        legendViewModels = SSFlowLayoutViewModel.mockData
        setupView()
        applySnapshot(animated: true)
    }

    // MARK: - Actions
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        // 更新 bottomCollectionView 布局
        guard let alignmentType = SSEqualCellSpaceFlowLayoutAlignmentType(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        let nextLayout = makeEqualSpaceFlowLayout(alignmentType: alignmentType)
        bottomCollectionView.setCollectionViewLayout(nextLayout, animated: false)
        bottomCollectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Private
extension SSFlowLayoutCollectionViewController {
    private func setupView() {
        view.backgroundColor = UIColor(hex: 0x141414)

        // topTitleLabel
        topTitleLabel = UILabel(frame: .zero)
        topTitleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        topTitleLabel.textColor = UIColor.white
        topTitleLabel.textAlignment = .natural
        topTitleLabel.text = "系统默认流式布局，Cell 两端分散对齐："
        view.addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(22)
        }

        // topCollectionView，使用系统默认流式布局
        let systemFlowLayout = makeSystemFlowLayout()
        topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: systemFlowLayout)
        topCollectionView.backgroundColor = UIColor.clear
        topCollectionView.showsHorizontalScrollIndicator = false
        topCollectionView.showsVerticalScrollIndicator = false
        topCollectionView.alwaysBounceVertical = false
        topCollectionView.isScrollEnabled = false
        topCollectionView.register(
            SSFlowLayoutLegendCell.self,
            forCellWithReuseIdentifier: SSFlowLayoutLegendCell.reuseIdentifier
        )
        topCollectionView.register(
            SSFlowLayoutLegendHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SSFlowLayoutLegendHeaderView.reuseIdentifier
        )

        // 连接集合视图与数据源
        topCollectionView.dataSource = topDataSource
        topCollectionView.delegate = self

        view.addSubview(topCollectionView)
        topCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topTitleLabel.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.snp.centerY)
        }

        // bottomTitleLabel
        bottomTitleLabel = UILabel(frame: .zero)
        bottomTitleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        bottomTitleLabel.textColor = UIColor.white
        bottomTitleLabel.textAlignment = .natural
        bottomTitleLabel.text = "自定义流式布局，Cell 均匀对齐："
        view.addSubview(bottomTitleLabel)
        bottomTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(22)
        }

        // segmentControl
        segmentControl = UISegmentedControl(frame: .zero)
        segmentControl.contentHorizontalAlignment = .fill
        segmentControl.apportionsSegmentWidthsByContent = false
        segmentControl.tintColor = UIColor.clear
        segmentControl.selectedSegmentTintColor = UIColor(hex: 0x828691, transparency: 0.24)
        segmentControl.backgroundColor = UIColor.clear
        segmentControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

        // 设置标题文本样式
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor(hex: 0x141414).require()], for: .selected)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor(hex: 0x9FA2AC).require()], for: .normal)

        // 从枚举生成 segment
        segmentControl.removeAllSegments()
        for aligmentType in SSEqualCellSpaceFlowLayoutAlignmentType.allCases {
            segmentControl.insertSegment(
                withTitle: aligmentType.displayName,
                at: aligmentType.rawValue,
                animated: false
            )
        }
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(bottomTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(38)
        }

        // bottomCollectionView，使用自定义流式布局
        let defaultAlignmentType = SSEqualCellSpaceFlowLayoutAlignmentType(rawValue: segmentControl.selectedSegmentIndex) ?? .left
        let equalSpaceFlowLayout = makeEqualSpaceFlowLayout(alignmentType: defaultAlignmentType)
        bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: equalSpaceFlowLayout)
        bottomCollectionView.backgroundColor = UIColor.clear
        bottomCollectionView.showsHorizontalScrollIndicator = false
        bottomCollectionView.showsVerticalScrollIndicator = false
        bottomCollectionView.alwaysBounceVertical = false
        bottomCollectionView.isScrollEnabled = false
        bottomCollectionView.register(
            SSFlowLayoutLegendCell.self,
            forCellWithReuseIdentifier: SSFlowLayoutLegendCell.reuseIdentifier
        )
        bottomCollectionView.register(
            SSFlowLayoutLegendHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SSFlowLayoutLegendHeaderView.reuseIdentifier
        )
        // 连接集合视图与数据源
        bottomCollectionView.dataSource = bottomDataSource
        bottomCollectionView.delegate = self

        view.addSubview(bottomCollectionView)
        bottomCollectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(5)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    // 系统默认布局，两端分散对齐
    private func makeSystemFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }

    // 自定义布局
    private func makeEqualSpaceFlowLayout(alignmentType: SSEqualCellSpaceFlowLayoutAlignmentType) -> SSEqualCellSpaceFlowLayout {
        let layout = SSEqualCellSpaceFlowLayout(cellAlignmentType: alignmentType, interItemSpacing: 12)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }

    private func makeDataSource(for collectionView: UICollectionView) -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SSFlowLayoutLegendCell.reuseIdentifier, for: indexPath) as? SSFlowLayoutLegendCell else {
                fatalError("Unable to dequeue 'SSFlowLayoutLegendCell'")
            }
            cell.configure(with: item)
            return cell
        }
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            guard elementKind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
            }
            guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: SSFlowLayoutLegendHeaderView.reuseIdentifier,
                    for: indexPath
                  ) as? SSFlowLayoutLegendHeaderView else {
                return UICollectionReusableView()
            }
            let ids = dataSource.snapshot().sectionIdentifiers
            guard indexPath.section < ids.count else { return header }
            header.configure(with: ids[indexPath.section])
            return header
        }
        return dataSource
    }

    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        let sections = legendViewModels.map { $0.section }
        snapshot.appendSections(sections)

        for sectionModel in legendViewModels {
            snapshot.appendItems(sectionModel.items, toSection: sectionModel.section)
        }
        return snapshot
    }

    private func applySnapshot(animated: Bool = true, reconfiguring items: [SSFlowLayoutItem] = []) {
        var snapshot = makeSnapshot()
        if !items.isEmpty {
            snapshot.reconfigureItems(items)
        }
        topDataSource.apply(snapshot, animatingDifferences: animated)
        bottomDataSource.apply(snapshot, animatingDifferences: animated)
    }
}

// MARK: - UICollectionViewDelegate
extension SSFlowLayoutCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        guard width > 0 else { return .zero }
        return CGSize(width: width, height: SSFlowLayoutLegendHeaderView.preferredHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)

        let dataSource = (collectionView === topCollectionView) ? topDataSource : bottomDataSource
        let snapshot = dataSource.snapshot()
        let sectionIds = snapshot.sectionIdentifiers
        guard indexPath.section < sectionIds.count else { return }
        let sectionId = sectionIds[indexPath.section]
        guard let currentItem = dataSource.itemIdentifier(for: indexPath) else { return }

        // 找到当前选中的模型，并更新模型的 isSelect 状态
        var updatedItem = currentItem
        updatedItem.isSelect.toggle()
        // 获取模型在数据源中的索引
        guard let sectionIndex = legendViewModels.firstIndex(where: { $0.section == sectionId }),
              let itemIndex = legendViewModels[sectionIndex].items.firstIndex(where: { $0.category == currentItem.category }) else {
            return
        }
        legendViewModels[sectionIndex].items[itemIndex] = updatedItem
        applySnapshot(animated: false, reconfiguring: [updatedItem])
    }
}
