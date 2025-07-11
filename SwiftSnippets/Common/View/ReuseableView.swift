//
//  ReuseableView.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/11.
//

import UIKit

protocol ReuseableView {
    static var reuseIdentifier: String { get }
}

extension ReuseableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseableView {}
extension UITableViewHeaderFooterView: ReuseableView {}
extension UICollectionReusableView: ReuseableView {}
