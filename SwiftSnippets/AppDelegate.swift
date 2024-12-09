//
//  AppDelegate.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/11/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    /**
     1. 如果没有在 Info.plist 文件中包含 scene 的配置数据，或者要动态更改场景配置数据，需要实现此方法。UIKit 会在创建新 scene 前调用此方法。
     2. 此方法会返回一个 UISceneConfiguration 对象，其中包含场景详细信息，包括要创建的场景类型，用于管理场景的委托对象，以及包含要显示的初始
        视图控制器的 storyboard。
     如果未实现此方法，则必须在 Info.plist 文件中提供场景配置数据。

     总结：默认在 Info.plist 中进行了配置，不用实现该方法也没有关系。如果没有配置就需要实现此方法，并返回一个 UISceneConfiguration 对象。
     配置参数中的 Application Session Role 是一个数组，每项有3个参数：
     Configuration Name: 当前配置的名字
     Delegate Class Name: 关联的 Scene 代理对象
     StoryBoard name: 这个 scene 使用的故事版

     此代理方法中调用的是配置名为 "Default Configuration" 的 Scene，则系统就会自动去调用 SceneDelegate 这个类。
     */
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // 当用户通过“应用切换器”关闭一个或多个 scene 时候会调用
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: 备忘录模式，恢复应用状态
    // 备忘录模式捕获并使对象的内部状态暴露出来。换句话说，它可以在某处保存你的东西，稍后在不违反封装的原则下恢复此对外暴露的状态。
    // 也就是说，私有数据仍然是私有的。

    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
}
