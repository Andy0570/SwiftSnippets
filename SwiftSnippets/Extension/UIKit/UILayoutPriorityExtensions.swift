//
//  UILayoutPriorityExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/10.
//

import UIKit

extension UILayoutPriority {
    /// Creates a priority which is almost required, but not 100%.
    ///
    /// - SeeAlso: <https://www.avanderlee.com/swift/auto-layout-programmatically/>
    static var almostRequired: UILayoutPriority {
        return UILayoutPriority(rawValue: 999)
    }

    /// Creates a priority which is not required at all.
    /// 
    /// - SeeAlso: <https://www.avanderlee.com/swift/auto-layout-programmatically/>
    static var notRequired: UILayoutPriority {
        return UILayoutPriority(rawValue: 0)
    }
}
