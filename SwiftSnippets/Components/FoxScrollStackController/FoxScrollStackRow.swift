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
    
    /// Location of the separator view.
    /// It's automatically managed when you change the axis of the parent stackview.
    internal var separatorAxis: NSLayoutConstraint.Axis = .horizontal {
        didSet {
            guard separatorAxis != oldValue else {
                return
            }
            didUpdateSeparatorViewContraintsIfNeeded()
            didUpdateSeparatorAxis()
            didUpdateSeparatorInsets()
            layoutIfNeeded()
        }
    }
    
    // MARK: - Public Properties
    
    /// Return the index of the row into the parent stack.
    public var index: Int? {
        return self.stackView?.indexOfRow(self)
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
    
    // MARK: - Manage Separator
    
    /// Separator view object.
    public let separatorView = FoxScrollStackSeparator()
    
    /// Specifies the default insets for cell's separator.
    /// By default the value applied is inerithed from the separator's insets configuration of the
    /// parent stackview at the time of the creation of the cell.
    /// You can however assign a custom insets for each separator.
    open var separatorInsets: UIEdgeInsets = .zero {
        didSet {
            didUpdateSeparatorInsets()
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
        guard let contentView else { return }
        
        clipsToBounds = true
        insetsLayoutMarginsFromSafeArea = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        layoutUI()
    }
    
    internal func layoutUI() {
        guard let contentView else { return }
        
        contentView.removeFromSuperview()
        
        addSubview(contentView)
        addSubview(separatorView)
        
        didUpdateContentViewContraints()
        didUpdateSeparatorViewContraintsIfNeeded()
        didUpdateSeparatorAxis()
        
        applyParentStackAttributes()
        
        separatorView.isHidden = isSeparatorHidden
        setNeedsUpdateConstraints()
    }
    
    open override func updateConstraints() {
        // called the event to update the height of the row.
        askForCutomizedSizeOfContentView(animated: false)
        
        super.updateConstraints()
    }
    
    private func applyParentStackAttributes() {
        guard let stackView = self.stackView else {
            return
        }
        
        rowInsets = stackView.rowInsets
        rowPadding = stackView.rowPadding
        rowBackgroundColor = stackView.rowBackgroundColor
        rowHighlightColor = stackView.rowHighlightColor
        
        separatorAxis = (stackView.axis == .horizontal ? .vertical : .horizontal)
        separatorInsets = stackView.separatorInsets
        
        separatorView.color = stackView.separatorColor
        separatorView.thickness = stackView.separatorThickness
        isSeparatorHidden = stackView.hideSeparators
    }
    
    // MARK: - Manage Separator
    
    private func didUpdateContentViewContraints() {
        guard let contentView else { return }
        
        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: rowPadding.bottom)
        bottomConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.required.rawValue - 1)
        
        paddingConstraints = ConstraintsHolder(
            top: contentView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: rowPadding.top),
            left: contentView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: rowPadding.left),
            bottom: bottomConstraint,
            right: contentView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: rowPadding.right)
        )
        
        paddingConstraints?.activateAll()
    }
    
    private func didUpdateSeparatorViewContraintsIfNeeded() {
        if separatorConstraints == nil {
            separatorConstraints = ConstraintsHolder(
                top: separatorView.topAnchor.constraint(equalTo: topAnchor),
                left: separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
                bottom: separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
                right: separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
            )
        }
    }
    
    private func didUpdateSeparatorAxis() {
        separatorConstraints?.top?.isActive = (separatorAxis == .vertical)
        separatorConstraints?.bottom?.isActive = true
        separatorConstraints?.left?.isActive = (separatorAxis == .horizontal)
        separatorConstraints?.right?.isActive = true
    }
    
    private func didUpdateSeparatorInsets() {
        separatorConstraints?.top?.constant = separatorInsets.top
        separatorConstraints?.bottom?.constant = (separatorAxis == .horizontal ? 0 : -separatorInsets.bottom)
        separatorConstraints?.left?.constant = separatorInsets.left
        separatorConstraints?.right?.constant = (separatorAxis == .vertical ? 0 : -separatorInsets.right)
    }
    
    // MARK: - Sizing the Controller
    
    internal func askForCutomizedSizeOfContentView(animated: Bool) {
        guard let customizableController = controller as? FoxScrollStackContainableController else {
            return // ignore, it's not implemented, use autolayout.
        }
        
        let currentAxis = stackView!.axis
        guard let bestSize = customizableController.scrollStackRowSizeForAxis(currentAxis, row: self, in: self.stackView!) else {
            // ignore, use autolayout in place for content view or if you have used views instead of controllers.
            // you need to set the heightAnchor in this case!
            return
        }
        
        switch bestSize {
            case .fixed(let value):
                setupRowToFixedValue(value)
            case .fitLayoutForAxis:
                setupRowSizeToFitLayout()
        }
    }
    
    private func setupRowToFixedValue(_ value: CGFloat) {
        guard let stackView, let contentView else { return }
        
        if stackView.axis == .vertical {
            contentView.width(constant: nil)
            contentView.height(constant: value)
        } else {
            contentView.width(constant: value)
            contentView.height(constant: nil)
        }
    }
    
    // 移除指定视图中的固定高度和固定宽度约束
    private func removeFixedDimensionConstraintsIfNeeded(_ contentView: UIView) {
        let fixedDimensions = contentView.constraints.filter {
            $0.firstAttribute == .height || $0.firstAttribute == .width
        }
        contentView.removeConstraints(fixedDimensions)
    }
    
    private func setupRowSizeToFitLayout() {
        guard let stackView, let contentView else { return }
        
        // If user changed the way of how the controller's view is resized
        // (ie from fixed height to auto-dimension) we should need to remove
        // attached constraints about height/width in order to leave the view to
        // auto resize according to its content.
        removeFixedDimensionConstraintsIfNeeded(contentView)
        
        var bestSize: CGSize!
        
    }
    
    // MARK: - Handle Touch
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = gestureRecognizer.view else {
            return false
        }
        
        let location = touch.location(in: view)
        var hitView = view.hitTest(location, with: nil)
        
        // Traverse the chain of superviews looking for any UIControls.
        while hitView != view && hitView != nil {
            if hitView is UIControl {
                // Ensure UIControls get the touches instead of the tap gesture.
                return false
            }
            hitView = hitView?.superview
        }
        
        return true
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard contentView?.isUserInteractionEnabled ?? false else {
            return
        }
        
        if let contentView = contentView as? FoxScrollStackRowHighlightable, contentView.isHighlightable {
            contentView.setIsHighlighted(true)
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard contentView?.isUserInteractionEnabled ?? false, let touch = touches.first else {
            return
        }
        
        let locationInSelf = touch.location(in: self)
        
        if let contentView = contentView as? FoxScrollStackRowHighlightable, contentView.isHighlightable {
            let isPointInsideCell = point(inside: locationInSelf, with: event)
            contentView.setIsHighlighted(isPointInsideCell)
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard contentView?.isUserInteractionEnabled ?? false else {
            return
        }
        
        if let contentView = contentView as? FoxScrollStackRowHighlightable, contentView.isHighlightable {
            contentView.setIsHighlighted(false)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard contentView?.isUserInteractionEnabled ?? false else {
            return
        }
        
        if let contentView = contentView as? FoxScrollStackRowHighlightable, contentView.isHighlightable {
            contentView.setIsHighlighted(false)
        }
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
