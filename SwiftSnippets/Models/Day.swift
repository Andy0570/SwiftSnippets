//
//  Day.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/22.
//

import Foundation

/// RWCalendarPicker 中的日期
struct Day {
    let date: Date
    let number: String // 在日历上显示当前日期对应的数字
    let isSelected: Bool
    let isWithinDisplayedMonth: Bool
}
