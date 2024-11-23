//
//  CalendarExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/8.
//

import Foundation

extension Calendar {
    /// 返回上一年的整数形式
    ///
    ///     let priorYearAsNumber = Calendar.current.priorYear()
    ///
    /// - Returns: Returns last year's year as an integer.
    /// - SeeAlso: <https://medium.com/livefront/10-swift-extensions-we-use-at-livefront-8b84de32f77b>
    func priorYear() -> Int {
        guard let priorYear = date(byAdding: .year, value: -1, to: Date()) else {
            return component(.year, from: Date()) - 1
        }
        return component(.year, from: priorYear)
    }
}

extension Calendar.Component {
    /// Format components.
    ///
    ///     Calendar.Component.month.formatted(numberOfUnits: 2, unitsStyle: .full) // 2 months
    ///     Calendar.Component.day.formatted(numberOfUnits: 15, unitsStyle: .short) // 15 days
    ///     Calendar.Component.year.formatted(numberOfUnits: 1, unitsStyle: .abbreviated) // 1y
    ///
    /// - Parameters:
    ///   - numberOfUnits: Count of units of component.
    ///   - unitsStyle: Style of formatting of units.
    /// - Returns: formatted string
    func formatted(numberOfUnits: Int, unitsStyle: DateComponentsFormatter.UnitsStyle = .full) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = unitsStyle
        formatter.zeroFormattingBehavior = .dropAll
        var dateComponents = DateComponents()
        dateComponents.setValue(numberOfUnits, for: self)
        return formatter.string(from: dateComponents)
    }
}
