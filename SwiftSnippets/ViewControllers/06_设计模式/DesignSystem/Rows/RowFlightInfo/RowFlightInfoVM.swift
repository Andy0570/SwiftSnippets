//
//  RowFlightInfoVM.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import Foundation
import MagazineLayout

struct FlightInfo: Hashable {
    let departureTime: String
    let departureAirport: String

    let arrivalTime: String
    let arrivalAirport: String
}

struct RowFlightInfoVM: MagazineCellDataType {
    var sizeMode: MagazineLayoutItemSizeMode {
        return MagazineLayoutItemSizeMode(widthMode: .fullWidth(respectsHorizontalInsets: true),
                                          heightMode: .static(height: 60))
    }

    let flightInfo: FlightInfo

    init(info: FlightInfo) {
        self.flightInfo = info
    }

    var diffHash: Int {
        return flightInfo.hashValue
    }

    func configurator() -> CellConfigurator {
        return RowFlightInfoConfigurator(item: self)
    }

    func didSelect() {
        //
    }
}
