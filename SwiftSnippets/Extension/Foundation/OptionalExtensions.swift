//
//  OptionalExtensions.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/12/10.
//

import Foundation

extension Optional where Wrapped == String {
    /// 检查可选字符串类型是否为空
    ///
    ///     var name: String?
    ///     if name.isNilOrEmpty { ... }
    ///
    /// - SeeAlso: <https://tanaschita.com/swift-extending-optionals/>
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
