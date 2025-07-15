//
//  PhotoStreamViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/14.
//

import UIKit

/// UICollectionView Custom Layout Tutorial: Pinterest
///
/// Reference: <https://www.kodeco.com/4829472-uicollectionview-custom-layout-tutorial-pinterest>
class PhotoStreamViewController: UICollectionViewController {
    private var photos = Photo.allPhotos()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }

        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }

        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)

        // Register cell classes
        collectionView.register(AnnotatedPhotoCell.self, forCellWithReuseIdentifier: AnnotatedPhotoCell.reuseIdentifier)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoStreamViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnnotatedPhotoCell.reuseIdentifier, for: indexPath) as? AnnotatedPhotoCell else {
            fatalError("Unable to Dequeue Cell: AnnotatedPhotoCell")
        }

        cell.photo = photos[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

// MARK: PinterestLayoutDelegate

extension PhotoStreamViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return photos[indexPath.item].image.size.height
    }
}
