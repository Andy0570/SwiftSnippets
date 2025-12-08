//
//  FoxScrollStackRowAnimator.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/8.
//

import UIKit

// MARK: - FoxScrollStackRowAnimatable

public protocol FoxScrollStackRowAnimatable {
    
    /// Animation main info.
    var animationInfo: FoxScrollStackAnimationInfo { get }
    
    /// Animation will start to hide or show the row.
    /// - Parameter toHide: hide or show transition.
    func willBeginAnimationTransition(toHide: Bool)
    
    /// Animation to hide/show the row did end.
    /// - Parameter toHide: hide or show transition.
    func didEndAnimationTransition(toHide: Bool)
    
    /// Animation transition.
    /// - Parameter toHide: hide or show transition.
    func animateTransition(toHide: Bool)
    
}

// MARK: - FoxScrollStackRowAnimatable Extension

public extension FoxScrollStackRowAnimatable where Self: UIViewController {
    
    var animationInfo: FoxScrollStackAnimationInfo {
        return FoxScrollStackAnimationInfo()
    }
    
    func animateTransition(toHide: Bool) {
        
    }
    
    func willBeginAnimationTransition(toHide: Bool) {
        
    }
    
    func didEndAnimationTransition(toHide: Bool) {
        
    }
}

// MARK: - FoxScrollStackAnimationInfo

public struct FoxScrollStackAnimationInfo {
    
    /// Duration of the animation. By default is set to `0.25`.
    var duration: TimeInterval
    
    /// Delay before start animation.
    var delay: TimeInterval
    
    /// The springDamping value used to determine the amount of `bounce`.
    /// Default Value is `0.8`.
    var springDamping: CGFloat
    
    public init(duration: TimeInterval = 0.25, delay: TimeInterval = 0, springDamping: CGFloat = 0.8) {
        self.duration = duration
        self.delay = delay
        self.springDamping = springDamping
    }
}

// MARK: - FoxScrollStackRowAnimator

internal class FoxScrollStackRowAnimator {
    
    /// Row to animate.
    private let targetRow: FoxScrollStackRow
    
    /// Final state after animation, hidden or not.
    private let toHidden: Bool
    
    /// Animation handler, used to perform actions for animation in `ScrollStack`.
    private let internalHandler: () -> Void
    
    /// Completion handler.
    private let completion: ((Bool) -> Void)?
    
    /// Target row if animatable.
    private var animatableRow: FoxScrollStackRowAnimatable? {
        return (targetRow.controller as? FoxScrollStackRowAnimatable) ?? (targetRow.contentView as? FoxScrollStackRowAnimatable)
    }
    
    // MARK: - Initialization
    
    init(row: FoxScrollStackRow, toHidden: Bool, internalHandler: @escaping () -> Void, completion:  ((Bool) -> Void)? = nil) {
        self.targetRow = row
        self.toHidden = toHidden
        self.internalHandler = internalHandler
        self.completion = completion
    }
    
    /// Execute animation.
    func execute() {
        animatableRow?.willBeginAnimationTransition(toHide: toHidden)
        
        let duration = animatableRow?.animationInfo.duration ?? 0.25
        let dampingRatio = animatableRow?.animationInfo.springDamping ?? 1
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: dampingRatio,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState],
                       animations: {
            self.animatableRow?.animateTransition(toHide: self.toHidden)
            self.internalHandler()
        }) { finished in
            self.animatableRow?.didEndAnimationTransition(toHide: self.toHidden)
            self.completion?(finished)
        }
    }
}
