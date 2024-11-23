//
//  UICollectionViewExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/10.
//

import UIKit

// MARK: - Layout

extension UICollectionView {
    /// 便捷方法，以动画方式更新布局
    ///
    /// - Parameter animated: update Layout with animation or not.
    func invalidateLayout(animated: Bool) {
        if animated {
            performBatchUpdates({
                self.collectionViewLayout.invalidateLayout()
            }, completion: nil)
        } else {
            collectionViewLayout.invalidateLayout()
        }
    }
}
