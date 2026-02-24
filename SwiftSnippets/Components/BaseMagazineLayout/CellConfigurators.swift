//
//  CellConfigurators.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/1/23.
//

import MagazineLayout

/// 类型占位协议
protocol GenericCell { }

/// Cell 配置协议。
protocol ConfigurableCell: GenericCell, Reusable {
    associatedtype DataType
    func configure(item: DataType)
}

/// 提供 diffHash，用于 diff 算法判断两个 item 是否一样（高性能刷新）。
protocol Diffable {
    var diffHash: Int { get }
}

/// 提供 sizeMode，告诉 MagazineLayout Cell 的尺寸策略。
protocol CellSizable: GenericCell {
    var sizeMode: MagazineLayoutItemSizeMode { get }
}

/// 定义 Cell 被选中时的行为。
protocol SelectableData {
    func didSelect()
}

/// Cell Configurators
/// 核心协议，描述如何配置一个 Cell。
protocol CellConfigurator: CellSizable, Diffable, SelectableData {
    static var cellType: GenericCell.Type { get }
    static var cellReuseIdentifier: String { get }

    func configure(cell: UIView)
    func didSelect()
}

/// defines that object should return its configurator
protocol CellConfigurable {
    func configurator() -> CellConfigurator
}

/// Cell 的 ViewModel 应该遵守的一组协议
typealias MagazineCellDataType = Diffable & CellSizable & SelectableData & CellConfigurable

/// MagazineCellConfigurator 是一个具有 DataType 和 CellType 类型约束的泛型类。它负责把 ViewModel 和 Cell 绑定到一起。
///
/// ### 参数
/// * `DataType`：必须遵守 `MagazineCellDataType`（= Diffable & CellSizable & SelectableData & CellConfigurable）。
/// * `CellType`：必须是 `ConfigurableCell`，且能配置 `DataType`。
///
/// ### 工作流程
/// 1. 保存一个 `item`（ViewModel）。
/// 2. 提供 Cell 的 `cellType` 和 `cellReuseIdentifier`（注册/复用）。
/// 3. 在 `configure(cell:)` 里，把 ViewModel 绑定给 Cell。
/// 4. 提供大小、diff hash 和点击事件。
///
/// 这样就能做到：不管有多少 Cell 类型，都能统一用同一个 Configurator 处理。
final class MagazineCellConfigurator<DataType: MagazineCellDataType, CellType: ConfigurableCell>: CellConfigurator where CellType.DataType == DataType, CellType: UIView {
    let item: DataType

    init(item: DataType) {
        self.item = item
    }

    static var cellType: GenericCell.Type { CellType.self }
    static var cellReuseIdentifier: String { CellType.reuseIdentifier }

    func configure(cell: UIView) {
        (cell as? CellType)?.configure(item: item)
    }

    var sizeMode: MagazineLayoutItemSizeMode { item.sizeMode }
    var diffHash: Int { item.diffHash }
    func didSelect() { item.didSelect() }
}

// MARK: -

/// Reusable cells like headers or footers
/// 提供 heightMode（高度策略）
protocol SupplementaryCellSizable: GenericCell {
    var heightMode: MagazineLayoutHeaderHeightMode { get }
}

/// 用于配置 header / footer / background
/// 此协议让我们可以在数组中保存泛型类而无需定义数据类型
protocol SupplementaryCellConfigurator: SupplementaryCellSizable, Diffable {
    static var cellType: GenericCell.Type { get }
    static var cellReuseIdentifier: String { get }

    func configure(cell: UIView)
}

protocol SupplementaryConfigurable {
    func configurator() -> SupplementaryCellConfigurator
}

/// Supplementary Cell 的 View Model 应该遵守的一组协议
typealias MagazineSupplementaryDataType = Diffable & SupplementaryCellSizable & SupplementaryConfigurable

/// 泛型 Supplementary Cell 配置器
final class MagazineSupplementaryCellConfigurator<DataType: MagazineSupplementaryDataType, CellType: ConfigurableCell>: SupplementaryCellConfigurator where CellType.DataType == DataType, CellType: UIView {
    let item: DataType

    init(item: DataType) {
        self.item = item
    }

    static var cellType: GenericCell.Type { CellType.self }
    static var cellReuseIdentifier: String { CellType.reuseIdentifier }

    func configure(cell: UIView) {
        (cell as? CellType)?.configure(item: item)
    }

    var heightMode: MagazineLayoutHeaderHeightMode { item.heightMode }
    var diffHash: Int { item.diffHash }
}
