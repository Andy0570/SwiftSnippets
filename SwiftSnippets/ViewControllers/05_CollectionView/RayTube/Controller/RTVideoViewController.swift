//
//  RTVideoViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/2/14.
//

import UIKit
import SafariServices

/// iOS Tutorial: Collection View and Diffable Data Source
/// Reference: <https://www.raywenderlich.com/8241072-ios-tutorial-collection-view-and-diffable-data-source>
final class RTVideoViewController: UICollectionViewController {
    // MARK: - Properties
    private lazy var dataSource = makeDataSource()

    private var sections = RTSection.allSections

    typealias DataSource = UICollectionViewDiffableDataSource<RTSection, RTVideo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<RTSection, RTVideo>

    private var searchController = UISearchController(searchResultsController: nil)

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureSearchController()
        configureLayout()
        applySnapshot(animatingDifferences: false)
    }

    private func makeDataSource() -> DataSource {
        // Cell
        let dataSource = DataSource(collectionView: collectionView, cellProvider: {collectionView, indexPath, video -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RTVideoCollectionViewCell", for: indexPath) as? RTVideoCollectionViewCell
            cell?.video = video
            return cell
        })

        // Section Header
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RTSectionHeaderReusableView.reuseIdentifier, for: indexPath) as? RTSectionHeaderReusableView
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            view?.titleLabel.text = section.title
            return view
        }

        return dataSource
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.videos, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - UICollectionViewDelegate
extension RTVideoViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let video = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        guard let link = video.link else {
            print("Invalid link")
            return
        }

        // 通过 Safari 浏览器打开链接
        let safariViewController = SFSafariViewController(url: link)
        present(safariViewController, animated: true, completion: nil)
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension RTVideoViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        sections = filteredSections(for: searchController.searchBar.text)
        applySnapshot()
    }

    func filteredSections(for queryOrNil: String?) -> [RTSection] {
        let sections = RTSection.allSections

        guard let query = queryOrNil, !query.isEmpty else {
            return sections
        }

        return sections.filter { section in
            var matches = section.title.lowercased().contains(query.lowercased())
            for video in section.videos {
                if video.title.localized().contains(query.lowercased()) {
                    matches = true
                    break
                }
            }
            return matches
        }
    }

    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Videos"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: - Layout Handling
extension RTVideoViewController {
    private func configureLayout() {
        collectionView.register(
            RTSectionHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: RTSectionHeaderReusableView.reuseIdentifier
        )

//        collectionView.register(
//            RTVideoCollectionViewCell.self,
//            forCellWithReuseIdentifier: "RTVideoCollectionViewCell"
//        )
        let cellNib = UINib(nibName: "RTVideoCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "RTVideoCollectionViewCell")

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { _, layoutEnvironment -> NSCollectionLayoutSection? in
            let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 280 : 250)
            )
            let itemCount = isPhone ? 1 : 3
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 10

            // Supplementary header view setup
            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(20)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]

            return section
        })
    }

    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}

// MARK: - SFSafariViewControllerDelegate Implementation
extension RTVideoViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
