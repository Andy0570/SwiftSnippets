//
//  UIDeviceExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/8.
//

import UIKit

extension UIDevice {
    /// 判断当前系统是否为 mac 系统
    var isMac: Bool {
        if #available(iOS 14.0, tvOS 14.0, *) {
            if UIDevice.current.userInterfaceIdiom == .mac {
                return true
            }
        }
        #if targetEnvironment(macCatalyst)
        return true
        #else
        return false
        #endif
    }
}

#if canImport(AudioToolbox)
import AudioToolbox

extension UIDevice {
    /// 一行代码实现系统振动反馈提示
    ///
    ///     UIDevice.vibrate()
    ///
    static func vibrate() {
        AudioServicesPlaySystemSound(1519)
    }
}

#endif
