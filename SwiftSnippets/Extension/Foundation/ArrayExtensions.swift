//
//  ArrayExtensions.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/11/23.
//

import Foundation

extension Array {
    /// Find the first element by a specific type in an array.
    /// - Parameter type: The specific type.
    /// - Returns: The first element whose type is same to the spcific type.
    func find<T>(by type: T.Type) -> T? {

        if let element = self.first(where: { (element) -> Bool in
            // FIXME:
            // The code here is complicated cause the result of String(describing: element.self) always return
            // some values with their memory addresses, "<Monotone.AuthService: 0x280e34a00>" etc.
            // I can not figure out the reason yet.

            let elementSplitedStrs = String(describing: element.self).components(separatedBy: ["."," ",":"])
            let typeStr = String(describing: type)

            return elementSplitedStrs.contains(typeStr)
        }) {
            return element as? T
        } else {
            print("Could not find element of type: '\(String(describing: type))'")
            return nil
        }
    }

    /// 从数组中获取随机元素
    ///
    /// - SeeAlso: <https://stackoverflow.com/questions/27259332/get-random-elements-from-array-in-swift>
    func choose(_ n: Int) -> Array {
        return Array(self.shuffled().prefix(n))
    }
}
