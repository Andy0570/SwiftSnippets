//
//  FoxScrollStack+Protocols.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/8.
//

import UIKit

// MARK: - FoxScrollStackContainableController

/// You can implement the following protocol in your view controller in order
/// to specify explictely (without using autolayout constraints) the best size (width/height depending
/// by the axis) of the controller when inside a scroll stack view.
public protocol FoxScrollStackContainableController: UIViewController {
    
    /// If you implement this protocol you can manage the size of the controller
    /// when is placed inside a `ScrollStackView`.
    /// This method is also called when scroll stack change the orientation.
    /// You can return `nil` to leave the opportunity to change the size to the
    /// controller's view constraints.
    /// By default it returns `nil`.
    ///
    /// - Parameter axis: axis of the stackview.
    /// - Parameter row: row where the controller is placed.
    /// - Parameter stackView: stackview where the row is placed.
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize?
    
    /// Method is called when you call a `reloadRow` function on a row where this controller is contained in.
    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool)
    
}

// MARK: - FoxScrollStackControllerDelegate

/// You can implement the following delegate to receive events about row visibility changes during scroll of the stack.
/// NOTE: No events are currently sent at the time of add/remove/move. A PR about is accepted :-)
public protocol FoxScrollStackControllerDelegate: AnyObject {
    
    /// Tells the delegate when the user scrolls the content view within the receiver.
    ///
    /// - Parameter stackView: target stack view.
    /// - Parameter offset: current scroll offset.
    func scrollStackDidScroll(_ stackView: FoxScrollStack, offset: CGPoint)
    
    /// Tells the delegate when a scrolling animation in the scroll view concludes.
    ///
    /// - Parameter stackView: The ScrollStack object that’s performing the scrolling animation.
    func scrollStackDidEndScrollingAnimation(_ stackView: FoxScrollStack)
    
    /// Row did become partially or entirely visible.
    ///
    /// - Parameter row: target row.
    /// - Parameter index: index of the row.
    /// - Parameter state: state of the row.
    func scrollStackRowDidBecomeVisible(_ stackView: FoxScrollStack, row: FoxScrollStackRow, index: Int, state: FoxScrollStack.RowVisibility)
    
    /// Row did become partially or entirely invisible.
    ///
    /// - Parameter row: target row.
    /// - Parameter index: index of the row.
    /// - Parameter state: state of the row.
    func scrollStackRowDidBecomeHidden(_ stackView: FoxScrollStack, row: FoxScrollStackRow, index: Int, state: FoxScrollStack.RowVisibility)
    
    /// This function is called when layout is updated (added, removed, hide or show one or more rows).
    /// - Parameter stackView: target stack view.
    func scrollStackDidUpdateLayout(_ stackView: FoxScrollStack)
    
    /// This function is called when content size of the stack did change (remove/add, hide/show rows).
    ///
    /// - Parameters:
    ///   - stackView: target stack view
    ///   - oldValue: old content size.
    ///   - newValue: new content size.
    func scrollStackContentSizeDidChange(_ stackView: FoxScrollStack, form oldValue: CGSize, to newValue: CGSize)
}

// MARK: - FoxScrollStackRowHighlightable

/// Indicates that a row into the stackview should be highlighted when the user touches it.
public protocol FoxScrollStackRowHighlightable {
    
    /// Checked when the user touches down on a row to determine if the row should be highlighted.
    ///
    /// The default implementation of this method always returns `true`.
    var isHighlightable: Bool { get }
    
    /// Called when the highlighted state of the row changes.
    /// Override this method to provide custom highlighting behavior for the row.
    ///
    /// The default implementation of this method changes the background color of the row to the `rowHighlightColor`.
    func setIsHighlighted(_ isHighlighted: Bool)
}

extension FoxScrollStackRowHighlightable where Self: UIView {
    
    public var isHighlightable: Bool {
        return true
    }
    
    public func setIsHighlighted(_ isHighlighted: Bool) {
        guard let row = superview as? FoxScrollStackRow else {
            return
        }
        
        row.backgroundColor = (isHighlighted ? row.rowHighlightColor : row.rowBackgroundColor)
    }
}

// MARK: - FoxScrollStack

public extension FoxScrollStack {
    
    /// Define the controller size.
    /// - `fixed`: fixed size in points.
    /// - `fitLayoutForAxis`: attempt to size the controller to fits its content set with autolayout.
    enum ControllerSize {
        case fixed(CGFloat)
        case fitLayoutForAxis
    }
    
    /// Insertion of the new row.
    /// - `top`: insert row at the top of the stack.
    /// - `bottom`: append the row at the end of the stack rows.
    /// - `atIndex`: insert at specified index. If index is invalid nothing happens.
    /// - `after`: insert after the location of specified row.
    /// - `before`: insert before the location of the specified row.
    enum InsertLocation {
        case top
        case bottom
        case atIndex(Int)
        case afterView(UIView)
        case beforeView(UIView)
        case after(UIViewController)
        case before(UIViewController)
    }
    
    /// Scrolling position
    /// - `middle`: row is in the middle x/y of the container when possible.
    /// - `final`: row left/top side is aligned to the left/top anchor of the container when possible.
    /// - `final`: row right/top side is aligned to the right/top anchor of the container when possible.
    /// - `automatic`: row is aligned automatically.
    enum ScrollPosition {
        case middle
        case final
        case initial
        case automatic
    }
    
    /// Row visibility
    /// - `partial`: row is partially visible.
    /// - `entire`: row is entirely visible.
    /// - `hidden`: row is invisible and hidden.
    /// - `offscreen`: row is not hidden but currently offscreen due to scroll position.
    /// - `removed`: row is removed manually.
    enum RowVisibility: Equatable {
        case hidden
        case partial(percentage: Double)
        case entire
        case offscreen
        case removed
        
        /// Return if row is visible.
        public var isVisible: Bool {
            switch self {
                case .hidden, .offscreen, .removed:
                    return false
                default:
                    return true
            }
        }
    }
}
