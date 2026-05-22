//
//  SSAnalysisSummaryData.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/5/20.
//

import SwiftyJSON

/// 模块枚举类型
enum SSAnalysisSummaryEnergyType: String, CaseIterable {
    case solar = "solar"
    case load = "load"
    case charge = "charge"
    case discharge = "discharge"
    case gridImport = "import"
    case gridExport = "export"
    case auxiliary = "aux"
    case diesel = "diesel"
    case none = ""

    /// 标题
    var displayName: String {
        switch self {
            case .solar: return "PV Production"
            case .load: return "Load Consumption"
            case .charge: return "Battery Charge"
            case .discharge: return "Battery Discharge"
            case .gridImport: return "Grid Imported"
            case .gridExport: return "Grid Exported"
            case .auxiliary: return "Gen Load"
            case .diesel: return "Diesel Gen"
            case .none: return ""
        }
    }

    /// 图标
    var imageName: String {
        switch self {
            case .solar: "analysis_pv_line"
            case .load: "analysis_load_line"
            case .charge: "analysis_battery_line"
            case .discharge: "analysis_battery_line"
            case .gridImport: "analysis_grid_import_line"
            case .gridExport: "analysis_grid_export_line"
            case .auxiliary: "analysis_pv_line"
            case .diesel: "analysis_generator_line"
            case .none: ""
        }
    }

    /// Card 颜色
    var color: UIColor {
        switch self {
            case .solar: return UIColor(hex: "#6929C4")
            case .load: return UIColor(hex: "#002D9C")
            case .charge: return UIColor(hex: "#009D9A")
            case .discharge: return UIColor(hex: "#1192E8")
            case .gridImport: return UIColor(hex: "#9F1853")
            case .gridExport: return UIColor(hex: "#EE5396")
            case .auxiliary: return UIColor(hex: "#005D5D")
            case .diesel: return UIColor(hex: "#FA4D56")
            case .none: return UIColor.white
        }
    }
}

struct SSAnalysisSummaryData: JSONable, Hashable {
    let energyType: SSAnalysisSummaryEnergyType
    let value: String
    let unit: String
    let noMeterFlag: Bool

    init(json: JSON) {
        energyType = SSAnalysisSummaryEnergyType(rawValue: json["key"].stringValue) ?? .none
        value = json["value"].stringValue
        unit = json["unit"].stringValue
        noMeterFlag = json["noMeterFlag"].boolValue
    }
}
