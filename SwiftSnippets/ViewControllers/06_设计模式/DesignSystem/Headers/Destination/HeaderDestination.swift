//
//  HeaderDestination.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/12.
//

import UIKit

final class HeaderDestination: UIView {
    static let height: CGFloat = 400
    static var minimumHeight: CGFloat { return 100 + UIApplication.shared.statusBarFrame.height }

    @IBOutlet weak var backButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backButtonTopConstraint.constant = UIApplication.shared.statusBarFrame.height + 4
    }
}
