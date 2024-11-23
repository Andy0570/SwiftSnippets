//
//  UIViewControllerExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2022/9/7.
//

import SwiftMessages

// MARK: - SwiftMessages Extensions
// 参考: <https://github.com/SwiftKickMobile/SwiftMessages>
extension UIViewController {
    func showSwiftMessageWithSuccess(_ title: String) {
        let successView = MessageView.viewFromNib(layout: .cardView)
        successView.configureTheme(.success)
        successView.configureDropShadow()
        successView.configureContent(title: title, body: "")
        successView.button?.isHidden = true
        successView.bodyLabel?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        SwiftMessages.show(config: successConfig, view: successView)
    }

    func showSwiftMessageWithError(_ title: String) {
        let errorView = MessageView.viewFromNib(layout: .cardView)
        errorView.configureContent(title: title, body: "")
        errorView.configureTheme(.error)
        errorView.button?.isHidden = true
        errorView.bodyLabel?.isHidden = true
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .top
        SwiftMessages.show(config: infoConfig, view: errorView)
    }

    func showSwiftMessageWithWarning(_ title: String) {
        let infoView = MessageView.viewFromNib(layout: .cardView)
        infoView.configureContent(title: title, body: "")
        infoView.configureTheme(.warning)
        infoView.button?.isHidden = true
        infoView.bodyLabel?.isHidden = true
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .top
        SwiftMessages.show(config: infoConfig, view: infoView)
    }

    func showSwiftMessageWithInfo(_ title: String) {
        let infoView = MessageView.viewFromNib(layout: .cardView)
        infoView.configureContent(title: title, body: "")
        infoView.configureTheme(.info)
        infoView.button?.isHidden = true
        infoView.bodyLabel?.isHidden = true
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .bottom
        SwiftMessages.show(config: infoConfig, view: infoView)
    }
}

// MARK: - Dark Mode
extension UIViewController {
    /// 返回一个 flag，描述当前 UI 是否处于深色模式
    public var isDarkMode: Bool {
        if #available(iOS 12.0, *) {
            return traitCollection.userInterfaceStyle == .dark
        }
        return false
    }
}
