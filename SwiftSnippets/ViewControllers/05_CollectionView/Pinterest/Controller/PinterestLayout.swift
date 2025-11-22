//
//  PinterestLayout.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/14.
//

import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    /// request the photo's height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
    weak var delegate: PinterestLayoutDelegate?

    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6

    /// an array to cache the caculated attributes
    ///
    /// 当调用 prepare() 方法时，为所有 item 计算属性，并将其缓存到此数组中，
    /// 当集合视图下次请求获取布局属性时，你可以有效地查询缓存，而不是每次重新计算。
    private var cache: [UICollectionViewLayoutAttributes] = []

    private var contentHeight: CGFloat = 0

    private var contentWidth: CGFloat {
        guard let collectionView else {
            return 0
        }

        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        // 1.仅当缓存为空，并且 collectionView 存在时，才会计算布局属性。
        guard cache.isEmpty, let collectionView else {
            return
        }

        // 2.根据列宽声明并填充 xOffset 数组
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }

        // yOffset 数组记录每列的 y 位置，初始值设为 0
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)

        // 3.
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            // 4.执行 frame 计算
            let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            // 5.
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            // 6.扩展 contentHeight 以容纳新计算项的 frame
            contentHeight = max(contentHeight, frame.maxY)
            // 根据当前 frame 推进该列的 yOffset
            yOffset[column] += height

            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        // Loop through the cache and look for items in the rect
        for attributes in cache {
            // 将缓存中 attributes.frame 与该 rect 相交的 attributes 添加到 visibleLayoutAttributes 中。
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }

        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
