//
//  Print.swift
//  SeaTao
//
//  Created by Qilin Hu on 2022/9/8.
//

import Foundation

/// 使用条件编译的方法，在 Release 版本中关闭控制台日志输出
///
/// - SeeAlso：<https://stackoverflow.com/questions/26913799/remove-println-for-release-version-ios-swift>
public func printLog(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    items.forEach {
        Swift.print("📝 File: \(file), Function: \(function), Line: \(line): \n\($0)", separator: " ", terminator: "\n")
    }
    #endif
}
