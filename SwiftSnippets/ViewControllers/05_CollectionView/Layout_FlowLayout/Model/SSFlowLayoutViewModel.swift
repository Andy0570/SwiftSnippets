//
//  SSFlowLayoutViewModel.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/23.
//

import Foundation
import UIKit

/// Section 模型
enum SSFlowLayoutSection: Hashable {
    case supplyData
    case usageData

    var displayTitle: String {
        switch self {
            case .supplyData:
                return "Supply Data"
            case .usageData:
                return "Usage Data"
        }
    }
}

/// Cell 模型
struct SSFlowLayoutItem: Hashable {
    let category: String
    let chartColor: UIColor
    var isSelect: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(category)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.category == rhs.category
    }
}

struct SSFlowLayoutViewModel {
    let section: SSFlowLayoutSection
    var items: [SSFlowLayoutItem]
}

extension SSFlowLayoutViewModel {
    // 静态属性，生成模拟数据
    static var mockData: [SSFlowLayoutViewModel] = [
        // Supply Data
        SSFlowLayoutViewModel(
            section: SSFlowLayoutSection.supplyData,
            items: [
                SSFlowLayoutItem(category: "Solar", chartColor: UIColor(hex: 0x42BE65).require(), isSelect: true),
                SSFlowLayoutItem(category: "Battery", chartColor: UIColor(hex: 0x08BDBA).require(), isSelect: true),
                SSFlowLayoutItem(category: "Grid", chartColor: UIColor(hex: 0x33B1FF).require(), isSelect: true),
                SSFlowLayoutItem(category: "Gen Load", chartColor: UIColor(hex: 0x78A9FF).require(), isSelect: true)
            ]
        ),
        // Usage Data
        SSFlowLayoutViewModel(
            section: SSFlowLayoutSection.usageData,
            items: [
                SSFlowLayoutItem(category: "Grid Export", chartColor: UIColor(hex: 0xBE95FF).require(), isSelect: true),
                SSFlowLayoutItem(category: "Battery Discharge", chartColor: UIColor(hex: 0xFF7EB6).require(), isSelect: true),
                SSFlowLayoutItem(category: "Load", chartColor: UIColor(hex: 0xFF8389).require(), isSelect: true),
                SSFlowLayoutItem(category: "Battery Charge", chartColor: UIColor(hex: 0xFF832B).require(), isSelect: true),
                SSFlowLayoutItem(category: "Grid Import", chartColor: UIColor(hex: 0xD2A106).require(), isSelect: true),
                SSFlowLayoutItem(category: "Generator", chartColor: UIColor(hex: 0xBBBEC6).require(), isSelect: true),
                SSFlowLayoutItem(category: "SOC_1", chartColor: UIColor(hex: 0x86B858).require(), isSelect: true),
                SSFlowLayoutItem(category: "SOC_2", chartColor: UIColor(hex: 0xEB6200).require(), isSelect: true)
            ]
        )
    ]
}
