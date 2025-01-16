//
//  OutlineButton.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/7.
//

import UIKit

/// 带圆角边框样式的 UIButton
/// 参考：<https://sarunw.com/posts/how-to-mark-custom-button-style-with-uibuttonconfiguration/>
final class OutlineButton: UIButton {
    override func updateConfiguration() {
        guard var updatedConfiguration = configuration else {
            return
        }

        var background = UIButton.Configuration.plain().background
        background.cornerRadius = 20
        background.strokeWidth = 1

        let strokeColor: UIColor
        let foregroundColor: UIColor
        let backgroundColor: UIColor
        let baseColor = updatedConfiguration.baseForegroundColor ?? UIColor.tintColor

        // 根据按钮状态设置不同的颜色
        switch self.state {
        case .normal:
            strokeColor = .systemGray5
            foregroundColor = baseColor
            backgroundColor = .clear
        case [.highlighted]:
            strokeColor = .systemGray5
            foregroundColor = baseColor
            backgroundColor = baseColor.withAlphaComponent(0.3)
        case .selected:
            strokeColor = .clear
            foregroundColor = .white
            backgroundColor = baseColor
        case [.selected, .highlighted]:
            strokeColor = .clear
            foregroundColor = .white
            backgroundColor = baseColor.darken()
        case .disabled:
            strokeColor = .systemGray6
            foregroundColor = baseColor.withAlphaComponent(0.3)
            backgroundColor = .clear
        default:
            strokeColor = .systemGray5
            foregroundColor = baseColor
            backgroundColor = .clear
        }

        background.strokeColor = strokeColor
        background.backgroundColorTransformer = UIConfigurationColorTransformer { _ in
            return backgroundColor
        }

        updatedConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var container = incoming
            container.foregroundColor = foregroundColor
            return container
        }
        updatedConfiguration.background = background

        self.configuration = updatedConfiguration
    }
}
