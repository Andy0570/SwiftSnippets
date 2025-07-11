//
//  FlickrPhotosViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/10.
//

import UIKit

/// UICollectionView 使用指南
/// 
/// 参考：
/// * <https://www.kodeco.com/18895088-uicollectionview-tutorial-getting-started>
/// * <https://www.kodeco.com/21959913-uicollectionview-tutorial-headers-selection-and-reordering>
final class FlickrPhotosViewController: UIViewController {
    // MARK: - Controls
    private weak var collectionView: UICollectionView!
    private var searchTextField: UITextField!
    private let shareTextLabel = UILabel()

    // MARK: - Properties
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 3
    private let flickr = FlickrService()

    private var searches: [FlickrSearchResults] = []
    private var selectedPhotos: [FlickrPhoto] = []

    var largePhotoIndexPath: IndexPath? {
        didSet {
            var indexPaths: [IndexPath] = []
            if let largePhotoIndexPath {
                indexPaths.append(largePhotoIndexPath)
            }

            // 如果用户之前已经选择了另一个 cell，或者想要点击相同的cell取消选中，则可能需要重新加载这两个 cell。
            if let oldValue {
                indexPaths.append(oldValue)
            }

            collectionView.performBatchUpdates {
                self.collectionView.reloadItems(at: indexPaths)
            } completion: { _ in
                if let largePhotoIndexPath = self.largePhotoIndexPath {
                    self.collectionView.scrollToItem(at: largePhotoIndexPath, at: .centeredVertically, animated: true)
                }
            }
        }
    }

    var isSharing = false {
        didSet {
            collectionView.allowsMultipleSelection = isSharing

            collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
            selectedPhotos.removeAll()

            guard let shareButton = navigationItem.rightBarButtonItems?.first else {
                return
            }

            guard isSharing else {
                navigationItem.setRightBarButtonItems([shareButton], animated: true)
                return
            }

            if largePhotoIndexPath != nil {
                largePhotoIndexPath = nil
            }

            updateSharedPhotoCountLabel()

            let sharingItem = UIBarButtonItem(customView: shareTextLabel)
            let items: [UIBarButtonItem] = [
                shareButton,
                sharingItem
            ]

            navigationItem.setRightBarButtonItems(items, animated: true)
        }
    }

    // 在 loadView() 方法中实例化视图并添加布局约束
    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.systemBackground
        view.addSubview(UIView(frame: .zero))

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // 自适应父view的宽高
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        self.collectionView = collectionView
    }

    // 在 viewDidLoad() 方法中配置视图
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        // searchTextField
        self.searchTextField = UITextField(frame: .zero)
        self.searchTextField.placeholder = "Search    "
        self.searchTextField.delegate = self
        // navigationItem.titleView?.addSubview(self.searchTextField)
        navigationItem.titleView = self.searchTextField

        // shareButtonItem
        let shareButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped(_:)))
        navigationItem.rightBarButtonItem = shareButtonItem

        // collectionView
        self.collectionView.backgroundColor = UIColor.systemBackground
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.dragInteractionEnabled = true
        self.collectionView.dragDelegate = self
        self.collectionView.dropDelegate = self

        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        // 注册重用（以代码方式创建的）Cell
        self.collectionView.register(FlickrPhotoCell.self, forCellWithReuseIdentifier: FlickrPhotoCell.reuseIdentifier)
        self.collectionView.register(FlickrPhotoHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FlickrPhotoHeaderView.reuseIdentifier)
    }

    // MARK: - Action

    @objc private func shareButtonTapped(_ sender: UIBarButtonItem) {
        guard !searches.isEmpty else {
            return
        }

        guard !selectedPhotos.isEmpty else {
            isSharing.toggle()
            return
        }

        guard isSharing else {
            return
        }

        // Add photo sharing logic
        let images: [UIImage] = selectedPhotos.compactMap { photo in
            guard let thumbnail = photo.thumbnail else {
                return nil
            }

            return thumbnail
        }

        guard !images.isEmpty else {
            return
        }

        let shareController = UIActivityViewController(activityItems: images, applicationActivities: nil)

        shareController.completionWithItemsHandler = { _, _, _, _ in
            self.isSharing = false
            self.selectedPhotos.removeAll()
            self.updateSharedPhotoCountLabel()
        }

        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true)
    }
}

// MARK: - Private

private extension FlickrPhotosViewController {
    func photo(for indexPath: IndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }

    func removePhoto(at indexPath: IndexPath) {
        searches[indexPath.section].searchResults.remove(at: indexPath.row)
    }

    func insertPhoto(_ flickrPhoto: FlickrPhoto, at indexPath: IndexPath) {
        searches[indexPath.section].searchResults.insert(flickrPhoto, at: indexPath.row)
    }

    func performLargeImageFetch(for indexPath: IndexPath, flickrPhoto: FlickrPhoto, cell: FlickrPhotoCell) {
        cell.activityIndicator.startAnimating()

        flickrPhoto.loadLargeImage { [weak self] result in
            cell.activityIndicator.stopAnimating()

            guard let self else { return }

            switch result {
            case let .success(photo):
                if indexPath == self.largePhotoIndexPath {
                    cell.imageView.image = photo.largeImage
                }
            case .failure:
                return
            }
        }
    }

    func updateSharedPhotoCountLabel() {
        if isSharing {
            shareTextLabel.text = "\(selectedPhotos.count) photos selected"
        } else {
            shareTextLabel.text = ""
        }

        shareTextLabel.textColor = UIColor.themeColor

        UIView.animate(withDuration: 0.3) {
            self.shareTextLabel.sizeToFit()
        }
    }
}

// MARK: - UITextFieldDelegate

extension FlickrPhotosViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return true
        }

        let activityIndicator = UIActivityIndicatorView(style: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()

        // 发起网络请求，搜索图片
        flickr.searchFlickr(for: text) { searchResults in
            DispatchQueue.main.async {
                activityIndicator.removeFromSuperview()

                switch searchResults {
                case .failure(let error):
                    print("Error Searching: \(error)")
                case .success(let results):
                    print("""
                      Found \(results.searchResults.count) \
                      matching \(results.searchTerm)
                      """)
                    self.searches.insert(results, at: 0)
                    self.collectionView?.reloadData()
                }
            }
        }

        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}

// MARK: UICollectionViewDataSource

extension FlickrPhotosViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrPhotoCell.reuseIdentifier, for: indexPath) as? FlickrPhotoCell else {
            fatalError("Invalid cell type")
        }

        let flickrPhoto = photo(for: indexPath)

        cell.activityIndicator.stopAnimating()

        guard indexPath == largePhotoIndexPath else {
            cell.imageView.image = flickrPhoto.thumbnail
            return cell
        }

        cell.isSelected = true
        guard flickrPhoto.largeImage == nil else {
            cell.imageView.image = flickrPhoto.largeImage
            return cell
        }

        // 如果不存在大图，优先显示缩略图，再下载大图
        cell.imageView.image = flickrPhoto.thumbnail
        performLargeImageFetch(for: indexPath, flickrPhoto: flickrPhoto, cell: cell)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(FlickrPhotoHeaderView.self)", for: indexPath)
                guard let typedHeaderView = headerView as? FlickrPhotoHeaderView else {
                    return headerView
                }

                let searchTerm = searches[indexPath.section].searchTerm
                typedHeaderView.titleLabel.text = searchTerm
                return typedHeaderView
            default:
                assert(false, "Invalid element type.")
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FlickrPhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // 非共享模式下，执行单选逻辑；否则，不做任何处理
        guard !isSharing else {
            return true
        }

        if largePhotoIndexPath == indexPath {
            largePhotoIndexPath = nil
        } else {
            largePhotoIndexPath = indexPath
        }

        return false
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard isSharing else {
            return
        }

        // 如果选中 cell，则添加模型到 selectedPhotos 数组，并更新 shareLabel。
        let flickrPhoto = photo(for: indexPath)
        selectedPhotos.append(flickrPhoto)
        updateSharedPhotoCountLabel()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard isSharing else {
            return
        }

        // 如果取消选中 cell，则删除 selectedPhotos 数组中对应的模型，并更新 shareLabel。
        let flickrPhoto = photo(for: indexPath)
        if let index = selectedPhotos.firstIndex(of: flickrPhoto) {
            selectedPhotos.remove(at: index)
            updateSharedPhotoCountLabel()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FlickrPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath == largePhotoIndexPath {
            let flickrPhoto = photo(for: indexPath)
            var size = collectionView.bounds.size
            size.height -= (sectionInsets.top + sectionInsets.right)
            size.width -= (sectionInsets.left + sectionInsets.right)
            return flickrPhoto.sizeToFillWidth(of: size)
        }

        // cell 宽度 =（页面宽度 - 空白边距）/ 每行的 cell 个数
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - UICollectionViewDragDelegate

extension FlickrPhotosViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let flickrPhoto = photo(for: indexPath)
        guard let thumbnail = flickrPhoto.thumbnail else {
            return []
        }

        let item = NSItemProvider(object: thumbnail)
        let dragItem = UIDragItem(itemProvider: item)

        return [dragItem]
    }
}

// MARK: - UICollectionViewDropDelegate

extension FlickrPhotosViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: any UIDropSession) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: any UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else {
            return
        }

        coordinator.items.forEach { dropItem in
            guard let sourceIndexPath = dropItem.sourceIndexPath else {
                return
            }

            collectionView.performBatchUpdates {
                let image = photo(for: sourceIndexPath)
                removePhoto(at: sourceIndexPath)
                insertPhoto(image, at: destinationIndexPath)

                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            } completion: { _ in
                // 执行 drop action
                coordinator.drop(dropItem.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: any UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}
