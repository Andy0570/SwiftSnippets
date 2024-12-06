//
//  IntExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2022/9/7.
//

import Foundation

extension Int {
    /// 社区图文，点赞数量
    var readableCount: String {
        var readableCount: String

        switch self {
        case 0..<1000:
            readableCount = String(self)
        case 1000..<10000:
            readableCount = String(format: "%.1f千", Float(self) / 1000)
        case 10000..<100000:
            readableCount = String(format: "%.1f万", Float(self) / 10000)
        default:
            readableCount = String(self)
        }
        return readableCount
    }
}
