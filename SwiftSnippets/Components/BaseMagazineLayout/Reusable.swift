//
//  Reusable.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/1/23.
//

import UIKit

/// 为可复用视图提供统一的标识符和 Nib 支持。
///
/// `Reusable` 通过约定类型名作为 `reuseIdentifier`，避免字符串硬编码，并提升类型安全性。
///
/// 通常用于 `UICollectionViewCell`、`UICollectionReusableView` 等可复用视图。
public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }

    static var nib: UINib? {
        return nil
    }
}

public extension UICollectionView {
    /// 注册可复用的 `UICollectionViewCell`。
    ///
    /// 使用 Cell 的类型名作为 `reuseIdentifier`，并自动支持基于 **Nib** 或 **Class** 的注册方式。
    ///
    /// ### 使用示例
    /// ```swift
    /// collectionView.registerReusableCell(MyCell.self)
    /// ```
    ///
    /// - Parameter _: 要注册的 Cell 类型（例如 `MyCell.self`，而非实例）。
    func registerReusableCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        if let nib = T.nib {
            self.register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }

    /// 注册可复用的 `UICollectionReusableView`（如 Header / Footer）。
    ///
    /// 该方法使用视图的类型名作为 `reuseIdentifier`，并根据 `Reusable.nib` 是否存在，
    /// 自动选择使用 **Nib** 或 **Class** 方式进行注册。
    ///
    /// 由于 Supplementary View 需要区分 `kind`，调用方必须显式指定其对应的 kind。
    ///
    /// ## 使用示例
    /// ```swift
    /// collectionView.registerReusableSupplementaryView(
    ///     MyHeaderView.self,
    ///     ofKind: UICollectionView.elementKindSectionHeader
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - _: 要注册的 Supplementary View 类型（例如 `MyHeaderView.self`）。
    ///   - kind: Supplementary View 的类型标识（如 `UICollectionView.elementKindSectionHeader`）。
    func registerReusableSupplementaryView<T: UICollectionReusableView>(_ type: T.Type, ofKind kind: String) where T: Reusable {
        if let nib = T.nib {
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
        } else {
            register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
        }
    }

    /// 返回指定类型的可复用 `UICollectionViewCell`。
    ///
    /// 该方法会使用 Cell 的类型名作为 `reuseIdentifier`，并返回强类型的 Cell 实例，无需手动进行类型转换。
    ///
    /// 调用前请确保已注册对应的 Cell 类型。
    ///
    /// ## 使用示例
    /// ```swift
    /// let cell: MyCell = collectionView.dequeueReusableCell(indexPath: indexPath)
    /// ```
    ///
    /// - Parameter indexPath: Cell 对应的 indexPath。
    /// - Returns: 对应类型的可复用 Cell 实例。
    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: Reusable {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }

    /// 返回指定类型的可复用 `UICollectionReusableView`（如 Header / Footer）。
    ///
    /// 该方法会使用视图的类型名作为 `reuseIdentifier`，并根据指定的 `kind` 返回对应的 Supplementary View 实例，
    /// 无需手动进行类型转换。
    ///
    /// 调用前请确保已注册对应的视图类型和 kind。
    ///
    /// ## 使用示例
    /// ```swift
    /// let header: MyHeaderView =
    ///     collectionView.dequeueReusableSupplementaryView(
    ///         ofKind: UICollectionView.elementKindSectionHeader,
    ///         indexPath: indexPath
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - kind: Supplementary View 的类型标识。
    ///   - indexPath: Supplementary View 对应的 indexPath。
    /// - Returns: 对应类型的可复用 Supplementary View 实例。
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, indexPath: IndexPath) -> T where T: Reusable {
        return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

public extension String {
    static func className(_ obj: AnyObject) -> String {
        return String(describing: obj.self).components(separatedBy: ".").last!
    }

    static func className(_ cls: AnyClass) -> String {
        return String(describing: cls).components(separatedBy: ".").last!
    }
}

public extension UIView {
    static func viewFromXib<T: UIView>(_ aBundle: Bundle? = nil) -> T {
        return UINib(nibName: String.className(T.self), bundle: aBundle).instantiate(withOwner: nil, options: nil)[0] as! T
    }
}
