//
//  NSLayoutConstraintExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/10.
//

import UIKit

public extension NSLayoutConstraint {
    /// Returns the constraint sender with the passed priority.
    ///
    /// - Parameter priority: The priority to be set.
    /// - Returns: The sended constraint adjusted with the new priority.
    /// - SeeAlso: <https://www.avanderlee.com/swift/auto-layout-programmatically/>
    func usingPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
