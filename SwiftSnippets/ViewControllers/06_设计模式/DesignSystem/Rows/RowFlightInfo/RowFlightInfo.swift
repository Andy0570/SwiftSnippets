//
//  RowFlightInfo.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import UIKit
import MagazineLayout

typealias RowFlightInfoConfigurator = MagazineCellConfigurator<RowFlightInfoVM, RowFlightInfo>

final class RowFlightInfo: MagazineLayoutCollectionViewCell, ConfigurableCell {
    static var nib: UINib? { return UINib(nibName: self.reuseIdentifier, bundle: nil) }

    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var departureDestinationLabel: UILabel!
    @IBOutlet weak var arrivalDestinationLabel: UILabel!

    func configure(item: RowFlightInfoVM) {
        self.departureTimeLabel.text = item.flightInfo.departureTime
        self.departureDestinationLabel.text = item.flightInfo.departureAirport

        self.arrivalTimeLabel.text = item.flightInfo.arrivalTime
        self.arrivalDestinationLabel.text = item.flightInfo.arrivalAirport
    }
}
