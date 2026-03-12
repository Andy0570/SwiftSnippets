//
//  RowDestinationTitle.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import UIKit
import MagazineLayout

typealias RowDestinationTitleConfigurator = MagazineCellConfigurator<RowDestinationTitleVM, RowDestinationTitle>

final class RowDestinationTitle: MagazineLayoutCollectionViewCell, ConfigurableCell {
    static var nib: UINib? { return UINib(nibName: self.reuseIdentifier, bundle: nil) }

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!

    func configure(item: RowDestinationTitleVM) {
        self.textLabel.text = item.title
    }
}
