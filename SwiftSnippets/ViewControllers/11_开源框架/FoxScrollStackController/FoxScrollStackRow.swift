//
//  FoxScrollStackRow.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/8.
//

import UIKit

// MARK: - FoxScrollStackRow

open class FoxScrollStackRow: UIView, UIGestureRecognizerDelegate {
    
    // MARK: - Private Properties
    
    /// Weak reference to the parent stack view.
    private weak var stackView: FoxScrollStack?
    
    /// Tap gesture recognizer.
    private lazy var onTapGestureRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        
        gesture.addTarget(self, action: #selector(handleTap(_:)))
        gesture.delegate = self
        addGestureRecognizer(gesture)
        gesture.isEnabled = false
        
        return gesture
    }()
    
    /// Constraints to handle separator's insets changes.
    private var separatorConstraints: ConstraintsHolder?
    
    /// Constraints to handle controller's view padding changes.
    private var paddingConstraints: ConstraintsHolder?
    
    internal var separatorAxis: NSLayoutConstraint.Axis = .horizontal {
        didSet {
            guard separatorAxis != oldValue else {
                return
            }
            
        }
    }
    
    // MARK: - Public Properties
    
    /// Return the index of the row into the parent stack.
    public var index: Int? {
        
    }
    
    /// Row highlight color.
    open var rowHighlightColor = FoxScrollStack.defaultRowColor
    
    /// Row background color.
    open var rowBackgroundColor = FoxScrollStack.defaultRowHighlightColor {
        didSet {
            backgroundColor = rowBackgroundColor
        }
    }
    
    /// Callback called when a tap is performed on row.
    /// By default row is not tappable.
    public var onTap: ((FoxScrollStackRow) -> Void)? {
        didSet {
            onTapGestureRecognizer.isEnabled = (onTap != nil)
        }
    }
    
    /// Parent controller.
    /// This value maybe `nil` if you use just `view` and not controller as row.
    ///
    /// NOTE:
    /// This value is strongly retained so you don't need to
    /// save it anywhere in your parent controller in order to avoid releases.
    public private(set) var controller: UIViewController?
    
    /// Content view controller (if controller is used) or just the view addded.
    ///
    /// NOTE: This value is strongly retained.
    public private(set) var contentView: UIView?
    
    // MARK: - Manager Separator
    
    /// Separator view object.
    public separatorView = FoxScrollStackSeparator()
    
    open var separatorInsets: UIEdgeInsets = .zero {
        didSet {
            
        }
    }
    
    open var isSeparatorHidden: Bool {
        didSet {
            separatorView.isHidden = isSeparatorHidden
        }
    }
    
    // MARK: Private Properties
    
    @objc private func handleTap(_ tapGestureRecognizer: UITapGestureRecognizer) {
        guard contentView?.isUserInteractionEnabled ?? false else {
            return
        }
        onTap?(self)
    }
    
    open var rowInsets: UIEdgeInsets {
        get {
            return layoutMargins
        }
        set {
            layoutMargins = newValue
        }
    }
    
    open var rowPadding: UIEdgeInsets {
        didSet {
            paddingConstraints?.updateInsets(rowPadding)
        }
    }
    
    open override var isHidden: Bool {
        didSet {
            guard isHidden != oldValue else {
                return
            }
            separatorView.alpha = (isHidden ? 0 : 1)
        }
    }
    
    // MARK: - Initialization
    internal init(view: UIView, stackView: FoxScrollStack) {
        self.stackView = stackView
        self.controller = nil
        self.contentView = view
        self.rowPadding = stackView.rowPadding
        self.isSeparatorHidden = stackView.isSeparatorHidden
        
        super.init(frame: .zero)
        
        setupPostInit()
    }
    
    internal init(controller: UIViewController, stackView: FoxScrollStack) {
        self.stackView = stackView
        self.controller = controller
        self.contentView = nil
        self.rowPadding = stackView.rowPadding
        self.isSeparatorHidden = stackView.isSeparatorHidden
        
        super.init(frame: .zero)
        
        setupPostInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    public func removeFromStackView() {
        contentView?.removeFromSuperview()
        contentView = nil
        controller = nil
        
        stackView?.stackView.removeArrangedSubview(self)
        removeFromSuperview()
    }
    
    private func setupPostInit() {
        guard let contentView else {
            return
        }
        
        clipsToBounds = true
        insetsLayoutMarginsFromSafeArea = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        layoutUI()
    }
    
    internal func layoutUI() {
        guard let contentView else {
            return
        }
        
        contentView.removeFromSuperview()
        
        addSubview(contentView)
        addSubview(separatorView)
        
        
    }
    
    // MARK: - Manage Separator
    
    private func didUpdateContentViewContraints() {
        guard let contentView else {
            return
        }
        
        
    }
    
    private func didUpdateSeparatorViewContraintsIfNeeded() {
        
    }
    
    private func didUpdateSeparatorAxis() {
        
    }
    
    private func didUpdateSeparatorInsets() {
        
    }
    
}

// MARK: - ConstraintsHolder

fileprivate class ConstraintsHolder {
    var top: NSLayoutConstraint?
    var left: NSLayoutConstraint?
    var bottom: NSLayoutConstraint?
    var right: NSLayoutConstraint?
    
    init(top: NSLayoutConstraint?, left: NSLayoutConstraint?,
         bottom: NSLayoutConstraint?, right: NSLayoutConstraint?) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
    
    func activateAll() {
        [top, left, bottom, right].forEach { $0?.isActive = true }
    }
    
    func updateInsets(_ insets: UIEdgeInsets) {
        top?.constant = insets.top
        bottom?.constant = insets.bottom
        left?.constant = insets.left
        right?.constant = insets.right
    }
}
