//
//  SSMarquee3Controller.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/29.
//

import UIKit
import SnapKit

final class SSMarquee3Controller: UIViewController {
    private let marqueeView = FoxMarqueeView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray

        // 跑马灯自定义视图
        let customView = SSMarqueeCustomView()
        marqueeView.contentView = customView
        marqueeView.marqueeDirection = .left
        marqueeView.pointsPerFrame = 1.0
        self.view.addSubview(marqueeView)
        marqueeView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
            make.height.equalTo(500)
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
extension SSMarquee3Controller: FoxScrollStackContainableController {
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fitLayoutForAxis
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
    }
}
