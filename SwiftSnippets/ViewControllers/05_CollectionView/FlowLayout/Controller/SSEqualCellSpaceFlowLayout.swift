//
//  SSEqualCellSpaceFlowLayout.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/23.
//

import UIKit

/// 流式布局中 Cell 的对齐方式
enum SSEqualCellSpaceFlowLayoutAlignmentType: Int, CaseIterable {
    case left = 0 // 左对齐
    case center = 1 // 居中对齐
    case right = 2 // 右对齐

    /// UI 页面显示的名称
    var displayName: String {
        switch self {
            case .left:
                return "Left"
            case .center:
                return "Center"
            case .right:
                return "Right"
        }
    }
}

/// Cell 间距始终均匀相等的流式布局
final class SSEqualCellSpaceFlowLayout: UICollectionViewFlowLayout {
    // 两个 Cell 之间的距离，默认值 12.0。
    private var interItemSpacing: CGFloat {
        didSet {
            self.minimumInteritemSpacing = interItemSpacing
        }
    }

    // Cell 对齐方式
    private var cellAlignmentType: SSEqualCellSpaceFlowLayoutAlignmentType = .center

    override init() {
        interItemSpacing = 12.0
        super.init()
        scrollDirection = .vertical
        minimumLineSpacing = 12.0
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }

    convenience init(cellAlignmentType: SSEqualCellSpaceFlowLayoutAlignmentType) {
        self.init()
        self.cellAlignmentType = cellAlignmentType
    }

    convenience init(cellAlignmentType: SSEqualCellSpaceFlowLayoutAlignmentType, interItemSpacing: CGFloat) {
        self.init()
        self.cellAlignmentType = cellAlignmentType
        self.interItemSpacing = interItemSpacing
    }

    required init?(coder aDecoder: NSCoder) {
        interItemSpacing = 12.0
        super.init(coder: aDecoder)
        scrollDirection = .vertical
        minimumLineSpacing = 12.0
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let baseAttributes = super.layoutAttributesForElements(in: rect) ?? []
        let layoutAttributes: [UICollectionViewLayoutAttributes] = NSArray(array: baseAttributes, copyItems: true) as! [UICollectionViewLayoutAttributes]
        var rowAttributes: [UICollectionViewLayoutAttributes] = []
        var rowCellWidth: CGFloat = 0.0

        for index in 0..<layoutAttributes.count {
            let currentAttr = layoutAttributes[index]
            let nextAttr = index + 1 == layoutAttributes.count ? nil : layoutAttributes[index + 1]

            // 仅让 Cell 参与等间距重排；header/footer 保持系统默认布局。
            guard currentAttr.representedElementCategory == .cell else {
                if !rowAttributes.isEmpty {
                    self.applyAlignment(to: rowAttributes, rowCellWidth: rowCellWidth)
                    rowAttributes.removeAll()
                    rowCellWidth = 0.0
                }
                continue
            }

            rowAttributes.append(currentAttr)
            rowCellWidth += currentAttr.frame.size.width

            let isNextCellInSameRow: Bool = {
                guard let nextAttr, nextAttr.representedElementCategory == .cell else { return false }
                return abs(nextAttr.frame.maxY - currentAttr.frame.maxY) < 0.5
            }()

            if !isNextCellInSameRow {
                self.applyAlignment(to: rowAttributes, rowCellWidth: rowCellWidth)
                rowAttributes.removeAll()
                rowCellWidth = 0.0
            }
        }
        return layoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    /// 调整Cell的Frame
    ///
    /// - Parameter layoutAttributes: layoutAttribute 数组
    private func applyAlignment(to layoutAttributes: [UICollectionViewLayoutAttributes], rowCellWidth: CGFloat) {
        guard let collectionView else { return }

        var currentWidthOffset: CGFloat = 0.0
        switch cellAlignmentType {
            case .left:
                currentWidthOffset = self.sectionInset.left
                for attributes in layoutAttributes {
                    var frame = attributes.frame
                    frame.origin.x = currentWidthOffset
                    attributes.frame = frame
                    currentWidthOffset += frame.size.width + self.interItemSpacing
                }
            case .center:
                // 整体起点 = (collectionWidth - 总cell宽 - 总间距) / 2
                currentWidthOffset = (collectionView.frame.size.width - rowCellWidth - (CGFloat(layoutAttributes.count - 1) * interItemSpacing)) / 2
                for attributes in layoutAttributes {
                    var frame = attributes.frame
                    frame.origin.x = currentWidthOffset
                    attributes.frame = frame
                    currentWidthOffset += frame.size.width + self.interItemSpacing
                }
            case .right:
                currentWidthOffset = collectionView.frame.size.width - self.sectionInset.right
                for var index in 0 ..< layoutAttributes.count {
                    index = layoutAttributes.count - 1 - index
                    let attributes = layoutAttributes[index]
                    var frame = attributes.frame
                    frame.origin.x = currentWidthOffset - frame.size.width
                    attributes.frame = frame
                    currentWidthOffset = currentWidthOffset - frame.size.width - interItemSpacing
                }
        }
    }
}
