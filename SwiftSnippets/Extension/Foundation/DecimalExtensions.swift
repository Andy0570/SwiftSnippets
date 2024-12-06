//
//  DecimalExtensions.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/11/23.
//

import Foundation

extension Decimal {
    /// 将带小数的数字转换为字符串
    ///
    /// - Parameter digit: 小数点后留的位数
    /// - Returns: 返回的字符串
    /// - SeeAlso: <https://stackoverflow.com/questions/46933209/how-to-convert-decimal-to-string-with-two-digits-after-separator>
    func format(digit: Int = 0) -> String? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = digit
        formatter.maximumFractionDigits = digit
        return formatter.string(from: self as NSDecimalNumber)
    }
}
