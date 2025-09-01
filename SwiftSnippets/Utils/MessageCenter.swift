//
//  MessageCenter.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/11/22.
//

import SwiftMessages

/// 通知栏，对 SwiftMessages 的封装
///
/// - SeeAlso: <https://github.com/SwiftKickMobile/SwiftMessages>
final class MessageCenter: Sendable {
    static let shared = MessageCenter()
    private init() {} // 这样可以防止其他对象使用这个类的默认 '()' 初始化器。

    func showMessage(
        title: String,
        body: String,
        theme: Theme = .success,
        buttonText: String? = nil,
        buttonTapHandler: (() -> Void)? = nil,
        tapHandler: (() -> Void)? = nil
    ) {
        Task { @MainActor in
            SwiftMessages.show {
                let view = MessageView.viewFromNib(layout: .cardView)
                view.configureDropShadow()
                view.configureContent(title: title, body: body)
                view.configureTheme(theme)

                if let buttonTapHandler {
                    view.buttonTapHandler = { _ in
                        buttonTapHandler()
                    }
                    view.button?.setTitle(buttonText, for: .normal)
                    view.button?.isHidden = false
                } else {
                    view.button?.isHidden = true
                }

                if let tapHandler {
                    view.tapHandler = { _ in
                        tapHandler()
                    }
                }

                return view
            }
        }
    }

    /**
     显示成功信息示例：
     `MessageCenter.shared.showSuccess(title: "提交成功")`
     `MessageCenter.shared.showSuccess(title: "退出登录成功")`
     */
    func showSuccess(title: String, body: String = "") {
        showMessage(title: title, body: body, theme: .success)
    }

    /**
     显示错误信息示例：
     `MessageCenter.shared.showError(title: "提交失败")`
     `MessageCenter.shared.showError(title: "网络加载失败", body: error.localizedDescription)`
     `MessageCenter.shared.showError(title: "错误提示", body: error.localizedDescription)`
     */
    func showError(title: String, body: String = "") {
        showMessage(title: title, body: body, theme: .error)
    }

    // 示例：`MessageCenter.shared.showWarning(title: "请填写姓名")`
    func showWarning(title: String, body: String = "") {
        showMessage(title: title, body: body, theme: .warning)
    }

    // 示例：`MessageCenter.shared.showInfo(title: "请填写姓名")`
    func showInfo(title: String, body: String = "") {
        showMessage(title: title, body: body, theme: .info)
    }
}
