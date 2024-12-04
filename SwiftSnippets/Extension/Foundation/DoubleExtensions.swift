//
//  DoubleExtensions.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/12/4.
//

import Foundation

extension Double {
    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        return formatter
    }()

    /// Double to String
    var formatted: String {
        return Double.formatter.string(for: self) ?? String(self)
    }

    /// Double to String，保留2位小数
    ///
    ///     let value = 15.67
    ///     let string = value.toString()
    ///
    /// - SeeAlso: <https://betterprogramming.pub/24-swift-extensions-for-cleaner-code-41e250c9c4c3>
    func toString() -> String {
        String(format: "%.02f", self)
    }
}
