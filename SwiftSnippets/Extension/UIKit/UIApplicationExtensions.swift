//
//  UIApplicationExtensions.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/9/1.
//

import UIKit

extension UIApplication {
    /// The app's key window.
    ///
    /// SeeAlso: <https://sarunw.com/posts/how-to-get-root-view-controller/>
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.windows
            .first(where: \.isKeyWindow)
    }

    /// Get the top most view controller from the base view controller; default param is UIWindow's rootViewController
    ///
    /// SeeAlso: <https://github.com/Esqarrouth/EZSwiftExtensions/blob/master/Sources/UIApplicationExtensions.swift>
    class func topViewController(_ base: UIViewController? = UIApplication.shared.firstKeyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
