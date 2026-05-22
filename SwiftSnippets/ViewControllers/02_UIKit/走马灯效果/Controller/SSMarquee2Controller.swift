//
//  SSMarquee2Controller.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/29.
//

import UIKit
import SnapKit

final class SSMarquee2Controller: UIViewController {
    private let marqueeView = FoxMarqueeView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray

        let label = UILabel(frame: .zero)
        label.text = "Your device firmware is outdated. Please upgrade for the best experience."
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.label

        marqueeView.contentView = label
        marqueeView.marqueeDirection = .left
        marqueeView.pointsPerFrame = 1.0
        self.view.addSubview(marqueeView)
        marqueeView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
            make.height.equalTo(50)
        }
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        marqueeView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 500)
//        marqueeView.center = self.view.center
//    }
}

// MARK: - FoxScrollStackContainableController
extension SSMarquee2Controller: FoxScrollStackContainableController {
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fitLayoutForAxis
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
