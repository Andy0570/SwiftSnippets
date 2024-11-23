//
//  UITabBarControllerExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/10.
//

import UIKit

public extension UITabBarController {
    func addTabBarItem(with controller: UIViewController, title: String, image: UIImage, selectedImage: UIImage? = nil) {
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage ?? image)
        controller.tabBarItem = tabBarItem
        if self.viewControllers == nil {
            self.viewControllers = [controller]
        } else {
            self.viewControllers?.append(controller)
        }
    }

    func addTabBarItem(with controller: UIViewController, _ item: UITabBarItem.SystemItem, tag: Int) {
        let tabBarItem = UITabBarItem.init(tabBarSystemItem: item, tag: tag)
        controller.tabBarItem = tabBarItem
        if self.viewControllers == nil {
            self.viewControllers = [controller]
        } else {
            self.viewControllers?.append(controller)
        }
    }
}
