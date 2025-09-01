//
//  ProductBarData.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/8/15.
//

import Foundation

struct BarData: Codable {
    let index: String
    let value: String
}

struct ProductBarData: Codable {
    let color: String
    let barData: [BarData]
}

extension ProductBarData {
    static func generateData() {
    }
}
