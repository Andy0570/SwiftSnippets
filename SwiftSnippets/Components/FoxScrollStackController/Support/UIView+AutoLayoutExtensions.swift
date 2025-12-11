//
//  UIView+AutoLayout_Extensions.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/8.
//

import UIKit

extension UIView {
    public func height(constant: CGFloat?) {
        setConstraint(value: constant, attribute: .height)
    }

    public func width(constant: CGFloat?) {
        setConstraint(value: constant, attribute: .width)
    }

    private func removeConstraint(attribute: NSLayoutConstraint.Attribute) {
        constraints.forEach {
            if $0.firstAttribute == attribute {
                removeConstraint($0)
            }
        }
    }

    private func setConstraint(value: CGFloat?, attribute: NSLayoutConstraint.Attribute) {
        removeConstraint(attribute: attribute)
        if let value = value {
            let constraint =
                NSLayoutConstraint(item: self,
                                   attribute: attribute,
                                   relatedBy: NSLayoutConstraint.Relation.equal,
                                   toItem: nil,
                                   attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                   multiplier: 1,
                                   constant: value)
            self.addConstraint(constraint)
        }
    }

    public static func execute(animated: Bool = true, _ callback: @escaping (() -> Void), completion: (() -> Void)? = nil) {
        guard animated else {
            callback()
            completion?()
            return
        }

        UIView.animate(withDuration: 0.3, animations: callback) { isFinished in
            if isFinished {
                completion?()
            }
        }
    }
}
