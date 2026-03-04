//
//  RWAlbumDetailViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/4.
//

import UIKit

class RWAlbumDetailViewController: UIViewController {
    static let syncingBadgeKind = "syncing-badge-kind"
    
    enum Section {
        case albumBody
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, RWAlbumDetailItem>! = nil
    var albumDetailCollectionView: UICollectionView! = nil
    
    var albumURL: URL?
    
    convenience init(withPhotosFromDirectory directory: URL) {
        self.init()
        albumURL = directory
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = albumURL?.lastPathComponent.displayNicely
        configureCollectionView()
        configureDataSource()
    }
}

extension RWAlbumDetailViewController {
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: <#T##UICollectionViewLayout#>)
    }
    
    private func configureDataSource() {
        
    }
    
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, RWAlbumDetailItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RWAlbumDetailItem>()
        snapshot.appendSections([Section.albumBody])
        let items = itemsFromAlbum()
        snapshot.appendItems(items)
        return snapshot
    }
    
    private func itemsFromAlbum() -> [RWAlbumDetailItem] {
        guard let albumURL = albumURL else {
            return []
        }
        do {
            return try FileManager.default.albumDetailItemsAtURL(albumURL)
        } catch {
            printLog(error)
            return []
        }
    }
    
    /**
     ### Size Classes 说明
     
     .fractionalWidth(): 使用 fractionalWidth 可以设置 cell 的宽度/高度相对于父视图宽度的比例；
     .fractionalHeight(): 使用 fractionalHeight 可以设置 cell 的宽度/高度相对于父视图高度的比例；
     .absolute(): 将 cell 的宽度/高度设置为绝对值；
     .estimate(): 使用估计值，我们可以根据内容大小设置 cell 的宽度/高度。系统将决定内容的最佳宽度/高度；
     */
    private func generateLayout() -> UICollectionViewLayout {
        // Syncing badge
        // 将 Supplementary View 的布局定义为距顶部和尾部 30% 的锚点，绝对宽度和高度为 20pt。
        let syncingBadgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: -0.3, y: 0.3))
        let syncingBadge = NSCollectionLayoutSupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(20), heightDimension: .absolute(20)),
            elementKind: RWAlbumDetailViewController.syncingBadgeKind,
            containerAnchor: syncingBadgeAnchor
        )
        
        // First type: Full
        // 第一种布局类型，宽度维度 = 1.0（全宽），高度维度 = 2/3 宽
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3)), supplementaryItems: [syncingBadge])
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // Second type: Main with pair
        // main item 的尺寸，组的全高、宽度是高度的 2/3
        let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))
        
    }
}

extension RWAlbumDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        let photoDetailVC = RWPhotoDetailViewController(photoURL: item.photoURL)
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}
