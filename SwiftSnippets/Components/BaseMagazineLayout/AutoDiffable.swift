//
//  AutoDiffable.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/1/23.
//

import Foundation

/// 自动生成 diffHash
protocol AutoDiffable: Diffable { }

extension AutoDiffable {
    var diffHash: Int {
        var hasher = Hasher()
        // 类型标识，保证不同 Cell 类型不会冲突
        hasher.combine(String(describing: type(of: self)))

        // 利用 Mirror 遍历属性，遍历所有可 Hash 属性
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let value = child.value as? (any Hashable) {
                hasher.combine(value)
            }
        }
        return hasher.finalize()
    }
}
