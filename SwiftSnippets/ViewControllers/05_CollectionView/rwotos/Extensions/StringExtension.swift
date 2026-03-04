//
//  StringExtension.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/4.
//

import Foundation

extension StringProtocol {
    /// 将字符串的第一个字符转为大写，其余部分保持不变
    ///
    ///     "swift".firstUppercased // "Swift"
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    /// 将字符串首字母大写，并把所有下划线 `_` 替换为空格
    ///
    ///     "hello_world".displayNicely // "Hello world"
    var displayNicely: String {
        return firstUppercased.replacingOccurrences(of: "_", with: " ")
    }
}
