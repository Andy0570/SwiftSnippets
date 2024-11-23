//
//  DateFormatterExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2022/9/7.
//

import Foundation

extension DateFormatter {
    /// 创建一个 iSO8601 格式 DateFormatter 实例的静态方法
    /// 2022-04-27T02:12:12.185+0000
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 3600 * 8) // 北京所在时区，东八区
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }()
}
