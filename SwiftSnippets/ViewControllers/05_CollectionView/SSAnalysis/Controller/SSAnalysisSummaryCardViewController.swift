//
//  SSAnalysisSummaryCardViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/5/20.
//

import UIKit

protocol SSAnalysisSummaryCardViewDelegate: AnyObject {
    /// 点击集合视图 cell item 时的回调
    func analysisSummaryCardViewController(_ controller: SSAnalysisSummaryCardViewController, didSelect item: SSAnalysisSummaryData)
    /// 点击集合视图 cell 上的 No Meter 按钮
    func analysisSummaryCardViewController(_ controller: SSAnalysisSummaryCardViewController, didTapNoMeter item: SSAnalysisSummaryData)
}


/// Analysis - Summary View Controller
/// 水平方向滚动的集合卡片视图
final class SSAnalysisSummaryCardViewController: UIViewController {
    // MARK: - Type Aliases
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, SSAnalysisSummaryData>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SSAnalysisSummaryData>

    // MARK: - Nested Types
    private enum Section: Hashable {
        case main
    }

    // MARK: - Controls
    private var collectionView: UICollectionView!

    // MARK: - Properties
    private lazy var dataSource = makeDataSource()

    weak var delegate: SSAnalysisSummaryCardViewDelegate?

    var analysisSummaryDataArray: [SSAnalysisSummaryData]? {
        didSet {
            guard let analysisSummaryDataArray else { return }
            applySnapshot(with: analysisSummaryDataArray, animated: false)
        }
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private
extension SSAnalysisSummaryCardViewController {
    private func setupView() {
        view.backgroundColor = UIColor.clear

        // collectionView
        let layout = makeCompositionalLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGroupedBackground // Test Color
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = false

        collectionView.register(SSAnalysisSummaryCardViewCell.self, forCellWithReuseIdentifier: SSAnalysisSummaryCardViewCell.reuseIdentifier)

        // 连接集合视图与数据源
        self.collectionView.dataSource = dataSource
        self.collectionView.delegate = self

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        // Cell 自适应宽度，固定高度 97
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(122),
            heightDimension: .absolute(97)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(122),
            heightDimension: .absolute(97)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal

        return UICollectionViewCompositionalLayout(section: section, configuration: config)
    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SSAnalysisSummaryCardViewCell.reuseIdentifier, for: indexPath) as? SSAnalysisSummaryCardViewCell else {
                fatalError("Unable to dequeue 'SSAnalysisSummaryCardViewCell'")
            }
            cell.configure(with: item)
            cell.didTapNoMeterButton = { [weak self] in
                guard let self else { return }
                self.delegate?.analysisSummaryCardViewController(self, didTapNoMeter: item)
            }
            return cell
        }
        return dataSource
    }

    private func applySnapshot(with items: [SSAnalysisSummaryData], animated: Bool = true) {
        // 创建一个 SnapShot 并填充数据
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        // 将 SnapShot 应用到数据源，以显示数据
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

// MARK: - UICollectionViewDelegate
extension SSAnalysisSummaryCardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        // 通过 Delegate 的方式实现回调
        delegate?.analysisSummaryCardViewController(self, didSelect: item)
    }
}

// MARK: - FoxScrollStackContainableController
extension SSAnalysisSummaryCardViewController: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(97)
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
        guard let analysisSummaryDataArray else { return }
        applySnapshot(with: analysisSummaryDataArray, animated: animated)
    }
}
