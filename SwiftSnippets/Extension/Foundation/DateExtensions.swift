//
//  DateExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/8.
//

import Foundation

extension Date {
    /// 给定一个 UTC iSO8601 格式的字符串，创建一个 Date 对象
    ///
    ///     let utcDateString = "2021-04-03T14:00:00.000Z"
    ///     let utcDate = Date.utcDate(from: utcDateString)
    ///
    /// - Parameter utcString: 用于创建日期的字符串
    /// - Returns: 根据给定字符串返回的日期
    /// - SeeAlso: <https://medium.com/livefront/10-swift-extensions-we-use-at-livefront-8b84de32f77b>
    static func utcDate(from utcString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")! // swiftlint:disable:this force_unwrapping
        return formatter.date(from: utcString)
    }
}
