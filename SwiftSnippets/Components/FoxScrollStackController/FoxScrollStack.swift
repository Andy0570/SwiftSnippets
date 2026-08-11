//
//  FoxScrollStack.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/8.
//

import UIKit

open class FoxScrollStack: UIScrollView, UIScrollViewDelegate {
    
    // MARK: Default Properties

    private static let defaultRowInsets = UIEdgeInsets(
        top: 12,
        left: UITableView().separatorInset.left,
        bottom: 12,
        right: UITableView().separatorInset.left
    )

    private static let defaultRowPadding: UIEdgeInsets = .zero

    public static let defaultSeparatorInset: UIEdgeInsets = UITableView().separatorInset
    public static let defaultSeparatorColor: UIColor = (UITableView().separatorColor ?? .clear)
    public static let defaultRowColor = UIColor.clear
    public static let defaultRowHighlightColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)

    /// Cached content size for did change content size callback in scrollstack delegate.
    private var cachedContentSize: CGSize = .zero

    // MARK: Public Properties

    /// The direction that rows are laid out in the stack view and scrolling works.
    /// By default direction is set to `.vertical`.
    open var axis: NSLayoutConstraint.Axis {
        get {
            return stackView.axis
        }
        set {
            stackView.axis = newValue
            didChangeAxis(newValue)
        }
    }

    // MARK: Public Properties (Rows)

    /// Rows currently active into the Scroll stack.
    public var rows: [FoxScrollStackRow] {
        return stackView.arrangedSubviews.compactMap { $0 as? FoxScrollStackRow }
    }

    /// Return all visible (partially or enterly) rows.
    public var visibleRows: [FoxScrollStackRow]? {
        return rows.enumerated().compactMap { idx, item in
            return (isRowVisible(index: idx).isVisible ? item : nil)
        }
    }

    /// Return only entirly visible rows.
    public var enterlyVisibleRows: [FoxScrollStackRow]? {
        return rows.enumerated().compactMap { idx, item in
            return (isRowVisible(index: idx) == .entire ? item : nil)
        }
    }

    /// Return `true` if no rows are into the stack.
    public var isEmpty: Bool {
        return rows.isEmpty
    }

    /// Get the first row of the stack, if any.
    public var firstRow: FoxScrollStackRow? {
        return rows.first
    }

    /// Get the last row of the stack, if any.
    public var lastRow: FoxScrollStackRow? {
        return rows.last
    }

    // MARK: Public Properties (Appearance)

    /// Set whether the layout margins of the superview should be included.
    /// iPad and iPhone have different layout margins and it allows to take care of it without
    /// having to set them directly.
    override open var preservesSuperviewLayoutMargins: Bool {
        didSet {
            stackView.preservesSuperviewLayoutMargins = preservesSuperviewLayoutMargins
            stackView.isLayoutMarginsRelativeArrangement = preservesSuperviewLayoutMargins
        }
    }

    /// Insets for rows.
    open var rowInsets: UIEdgeInsets = FoxScrollStack.defaultRowInsets {
        didSet {
            rows.forEach { row in
                row.rowInsets = rowInsets
            }
        }
    }

    /// Padding for rows `contentView` (the view of the view controller handled by row).
    open var rowPadding: UIEdgeInsets = FoxScrollStack.defaultRowPadding {
        didSet {
            rows.forEach { row in
                row.rowPadding = rowPadding
            }
        }
    }

    /// The color of separators in the stack view.
    /// You can set property for a single separator by setting new value inside the row's `separatoView`.
    open var separatorColor: UIColor = FoxScrollStack.defaultSeparatorColor {
        didSet {
            rows.forEach { row in
                row.separatorView.color = separatorColor
            }
        }
    }

    /// The thickness of the separator, by default is `1`.
    /// You can set property for a single separator by setting new value inside the row's `separatoView`.
    open var separatorThickness: CGFloat = 1.0 {
        didSet {
            rows.forEach { row in
                row.separatorView.thickness = separatorThickness
            }
        }
    }

    /// The insets of the separators.
    /// Default value is the `ScrollStack.defaultSeparatorInsets`.
    /// You can set property for a single separator by setting new value inside the row's `separatoView`.
    open var separatorInsets: UIEdgeInsets = FoxScrollStack.defaultSeparatorInset {
        didSet {
            rows.forEach { row in
                row.separatorInsets = separatorInsets
            }
        }
    }

    /// Hides or show separators.
    /// You can set property for a single separator by setting new value inside the row's `separatoView`.
    /// Kept in sync with `hideSeparators`.
    open var isSeparatorHidden: Bool = false {
        didSet {
            guard isSeparatorHidden != oldValue else { return }
            if hideSeparators != isSeparatorHidden {
                hideSeparators = isSeparatorHidden
            } else {
                applySeparatorHiddenToRows(isSeparatorHidden)
            }
        }
    }

    /// Hide automatically the last separator.
    open var autoHideLastRowSeparator = true {
        didSet {
            updateRowsSeparatorVisibility()
        }
    }

    /// Hide all separators.
    /// This not necessary reflect the current status of separator (you can also change this property individually per row).
    /// Once you set a new value it will be applied to any new added row and current rows.
    /// Kept in sync with `isSeparatorHidden`.
    open var hideSeparators = false {
        didSet {
            guard hideSeparators != oldValue else { return }
            if isSeparatorHidden != hideSeparators {
                isSeparatorHidden = hideSeparators
            } else {
                applySeparatorHiddenToRows(hideSeparators)
            }
        }
    }

    /// The background color of rows in the stack view.
    /// By default is set to `clear`.
    open var rowBackgroundColor = FoxScrollStack.defaultRowColor {
        didSet {
            rows.forEach { row in
                row.rowBackgroundColor = rowBackgroundColor
            }
        }
    }

    /// The highlight background color of rows in the stack view.
    /// By default is set to (rgb:0.85,0.85,0.85).
    open var rowHighlightColor = FoxScrollStack.defaultRowHighlightColor {
        didSet {
            rows.forEach { row in
                row.rowHighlightColor = rowHighlightColor
            }
        }
    }

    // MARK: Delegates

    /// Delegate event.
    /// If you set it to non `nil` value class will take the `UIScrollViewDelegate` events
    /// for its own.
    public weak var stackDelegate: FoxScrollStackControllerDelegate? {
        didSet {
            updateScrollViewDelegateOwnership()
        }
    }

    /// Optional standard `UIScrollViewDelegate` forwarded from this stack when it owns `delegate`.
    /// Use this when you also need classic scroll-view callbacks alongside `stackDelegate`.
    public weak var scrollViewDelegate: UIScrollViewDelegate? {
        didSet {
            updateScrollViewDelegateOwnership()
        }
    }

    // MARK: Private Properties

    /// Store the previous visibility state of the rows.
    private var prevVisibilityState = [FoxScrollStackRow: RowVisibility]()

    /// Event to monitor row changes
    internal var onChangeRow: ((_ row: FoxScrollStackRow, _ isRemoved: Bool) -> Void)?

    /// Inner stack view.
    public let stackView = UIStackView()

    /// Constraints to manage the main axis set.
    private var axisConstraint: NSLayoutConstraint?

    // MARK: Initialization

    public init() {
        super.init(frame: .zero)
        setupUI()
    }

    public required init?(coder: NSCoder) {
        fatalError("Initialization from IB not supported yet!")
    }

    // MARK: - Set Rows

    /// Remove all existing rows and put in place the new list based upon passed controllers.
    ///
    /// - Parameter controllers: controllers to set.
    @discardableResult
    open func setRows(controllers: [UIViewController]) -> [FoxScrollStackRow] {
        removeAllRows(animated: false)
        return addRows(controllers: controllers)
    }

    /// Remove all existing rows and put in place the new list based upon passed views.
    ///
    /// - Parameter views: views to set.
    @discardableResult
    open func setRows(views: [UIView]) -> [FoxScrollStackRow] {
        removeAllRows(animated: false)
        return addRows(views: views)
    }

    // MARK: - Insert Rows

    /// Insert a new to manage passed view without associated controller.
    ///
    /// - Parameters:
    ///   - view: view to add. It will be added as contentView of the row.
    ///   - location: location inside the stack of the new row.
    ///   - animated: `true` to animate operation, by default is `false`.
    ///   - completion: completion: optional completion callback to call at the end of insertion.
    @discardableResult
    open func addRow(view: UIView, at location: InsertLocation = .bottom, animated: Bool = false, completion: (() -> Void)? = nil) -> FoxScrollStackRow? {
        guard let index = indexForLocation(location) else {
            return nil
        }

        return createRowForView(view, insertAt: index, animated: animated, completion: completion)
    }

    /// Add new rows for each passed view.
    ///
    /// - Parameter controllers: controllers to add as rows.
    /// - Parameter location: location inside the stack of the new row.
    /// - Parameter animated: `true` to animate operatio, by default is `false`.
    @discardableResult
    open func addRows(views: [UIView], at location: InsertLocation = .bottom, animated: Bool = false) -> [FoxScrollStackRow] {
        enumerateItems(views, insertAt: location) {
            addRow(view: $0, at: location, animated: animated)
        }
    }

    /// Insert a new row to manage passed controller instance.
    ///
    /// - Parameter controller: controller to manage; it's `view` will be added as contentView of the row.
    /// - Parameter location: location inside the stack of the new row.
    /// - Parameter animated: `true` to animate operation, by default is `false`.
    /// - Parameter completion: optional completion callback to call at the end of insertion.
    @discardableResult
    open func addRow(controller: UIViewController, at location: InsertLocation = .bottom, animated: Bool = false, completion: (() -> Void)? = nil) -> FoxScrollStackRow? {
        guard let index = indexForLocation(location) else {
            return nil
        }

        return createRowForController(controller, insertAt: index, animated: animated, completion: completion)
    }

    /// Add new rows for each passed controllers.
    ///
    /// - Parameter controllers: controllers to add as rows.
    /// - Parameter location: location inside the stack of the new row.
    /// - Parameter animated: `true` to animate operatio, by default is `false`.
    @discardableResult
    open func addRows(controllers: [UIViewController], at location: InsertLocation = .bottom, animated: Bool = false) -> [FoxScrollStackRow] {
        enumerateItems(controllers, insertAt: location) {
            addRow(controller: $0, at: location, animated: animated)
        }
    }

    // MARK: - Reload Rows

    /// Perform a reload method by updating any constraint of the stack view's row.
    /// If row's managed controller implements `FoxScrollStackContainableController` it also call
    /// the reload event.
    ///
    /// - Parameter index: index of the row to reload.
    /// - Parameter animated: `true` to animate reload (any constraint change).
    /// - Parameter completion: optional completion callback to call.
    open func reloadRow(index: Int, animated: Bool = false, completion: (() -> Void)? = nil) {
        reloadRows(indexes: [index], animated: animated, completion: completion)
    }

    /// Perform a reload method on multiple rows.
    ///
    /// - Parameter indexes: indexes of the rows to reload.
    /// - Parameter animated: `true` to animate reload (any constraint change).
    /// - Parameter completion:  optional completion callback to call.
    open func reloadRows(indexes: [Int], animated: Bool = false, completion: (() -> Void)? = nil) {
        let selectedRows = safeRowsAtIndexes(indexes)
        reloadRows(selectedRows, animated: animated, completion: completion)
    }

    /// Reload all rows of the stack view.
    ///
    /// - Parameter animated: `true` to animate reload (any constraint change).
    /// - Parameter completion: optional completion callback to call.
    open func reloadAllRows(animated: Bool = false, completion: (() -> Void)? = nil) {
        reloadRows(rows, animated: animated, completion: completion)
    }

    // MARK: - Remove Rows

    /// Remove all rows currently in place into the stack.
    ///
    /// - Parameter animated: `true` to perform animated removeal, by default is `false`.
    open func removeAllRows(animated: Bool = false) {
        rows.forEach {
            removeRowFromStackView($0, animated: animated)
        }
    }

    /// Remove specified row.
    ///
    /// - Parameter row: row instance to remove.
    /// - Parameter animated: `true` to perform animation to remove item, by default is `false`.
    @discardableResult
    open func removeRow(index: Int, animated: Bool = false) -> UIViewController? {
        guard let row = safeRowAtIndex(index) else {
            return nil
        }
        return removeRowFromStackView(row, animated: animated)
    }

    /// Remove passed rows.
    ///
    /// - Parameter rowIndexes: indexes of the row to remove.
    /// - Parameter animated: `true` to animate the removeal, by default is `false`.
    @discardableResult
    open func removeRows(indexes rowIndexes: [Int], animated: Bool = false) -> [UIViewController]? {
        // Resolve rows first so shifting indexes after each removal cannot delete the wrong rows.
        let rowsToRemove = safeRowsAtIndexes(rowIndexes)
        return rowsToRemove.compactMap {
            return removeRowFromStackView($0, animated: animated)
        }
    }

    /// Replace an existing row with another new row which manage passed view.
    ///
    /// - Parameters:
    ///   - sourceIndex: row to replace.
    ///   - view: view to use as `contentView` of the row.
    ///   - animated: `true` to animate the transition.
    ///   - completion: optional callback called at the end of the transition.
    open func replaceRow(index sourceIndex: Int, withRow view: UIView, animated: Bool = false, completion: (() -> Void)? = nil) {
        doReplaceRow(index: sourceIndex, createRow: { index, animated -> FoxScrollStackRow in
            return self.createRowForView(view, insertAt: index, animated: animated)
        }, animated: animated, completion: completion)
    }

    /// Replace an existing row with another new row which manage passed controller.
    ///
    /// - Parameter row: row to replace.
    /// - Parameter controller: view controller to replace.
    /// - Parameter animated: `true` to animate the transition.
    /// - Parameter completion: optional callback called at the end of the transition.
    open func replaceRow(index sourceIndex: Int, withRow controller: UIViewController, animated: Bool = false, completion: (() -> Void)? = nil) {
        doReplaceRow(index: sourceIndex, createRow: { index, animated -> FoxScrollStackRow in
            return self.createRowForController(controller, insertAt: index, animated: animated)
        }, animated: animated, completion: completion)
    }

    /// Move the row at given index to another index.
    /// If one of the indexes is not valid nothing is made.
    ///
    /// - Parameter sourceIndex: source index.
    /// - Parameter destIndex: destination index.
    /// - Parameter animated: `true` to animate the transition.
    /// - Parameter completion: optional callback called at the end of the transition.
    open func moveRow(index sourceIndex: Int, to destIndex: Int, animated: Bool = false, completion: (() -> Void)? = nil) {
        guard sourceIndex >= 0, sourceIndex < rows.count,
              destIndex >= 0, destIndex < rows.count,
              sourceIndex != destIndex else {
            completion?()
            return
        }

        let sourceRow = rows[sourceIndex]

        func executeMoveRow() {
            // UIStackView moves an already-arranged view when re-inserted at a new index.
            stackView.insertArrangedSubview(sourceRow, at: destIndex)
            postInsertRow(sourceRow, animated: false)
            stackView.setNeedsLayout()
        }

        guard animated else {
            executeMoveRow()
            completion?()
            return
        }

        UIView.execute(executeMoveRow, completion: completion)
    }

    // MARK: - Show/Hide Rows

    /// Hide/Show row from the stack.
    /// Row is always on stack and it's returned from the `rows` property.
    ///
    /// - Parameter rowIndex: target row index.
    /// - Parameter isHidden: `true` to hide the row, `false` to make it visible.
    /// - Parameter animated: `true` to perform animated transition.
    /// - Parameter completion: completion callback called once the operation did finish.
    open func setRowHidden(index rowIndex: Int, isHidden: Bool, animated: Bool, completion: (() -> Void)? = nil) {
        guard let row = safeRowAtIndex(rowIndex) else {
            completion?()
            return
        }

        guard animated else {
            row.isHidden = isHidden
            completion?()
            return
        }

        guard row.isHidden != isHidden else {
            completion?()
            return
        }

        let coordinator = FoxScrollStackRowAnimator(row: row, toHidden: isHidden, internalHandler: {
            row.isHidden = isHidden
            row.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
        coordinator.execute()
    }

    /// Hide/Show selected rows.
    /// Rows is always on stack and it's returned from the `rows` property.
    ///
    /// - Parameter rowIndexes: indexes of the row to hide or show.
    /// - Parameter isHidden: `true` to hide the row, `false` to make it visible.
    /// - Parameter animated: `true` to perform animated transition.
    /// - Parameter completion: completion callback called once the operation did finish.
    open func setRowsHidden(indexes rowIndexes: [Int], isHidden: Bool, animated: Bool, completion: (() -> Void)? = nil) {
        guard rowIndexes.isEmpty == false else {
            completion?()
            return
        }

        for (offset, index) in rowIndexes.enumerated() {
            let isLast = offset == rowIndexes.count - 1
            setRowHidden(index: index, isHidden: isHidden, animated: animated, completion: isLast ? completion : nil)
        }
    }

    // MARK: - Row Appearance

    /// Return the first row which manages a controller of given type.
    ///
    /// - Parameter type: type of controller to get
    open func firstRowForControllerOfType<T: UIViewController>(_ type: T.Type) -> FoxScrollStackRow? {
        return rows.first {
            if let _ = $0.controller as? T {
                return true
            }
            return false
        }
    }

    /// Return the row associated with passed `UIView` instance and its index into the `rows` array.
    ///
    /// - Parameter view: target view (the `contentView` of the associated `FoxScrollStackRow` instance).
    open func rowForView(_ view: UIView) -> (index: Int, cell: FoxScrollStackRow)? {
        guard let index = rows.firstIndex(where: {
            $0.contentView == view
        }) else {
            return nil
        }

        return (index, rows[index])
    }

    /// Return the row associated with passed `UIViewController` instance and its index into the `rows` array.
    ///
    /// - Parameter controller: target controller.
    open func rowForController(_ controller: UIViewController) -> (index: Int, cell: FoxScrollStackRow)? {
        guard let index = rows.firstIndex(where: {
            $0.controller === controller
        }) else {
            return nil
        }

        return (index, rows[index])
    }

    /// Return `true` if controller is inside the stackview as a row.
    ///
    /// - Parameter controller: controller to check.
    open func containsRowForController(_ controller: UIViewController) -> Bool {
        return rowForController(controller)?.index != nil
    }

    /// Return the index of the row.
    /// It return `nil` if row is not part of the stack.
    ///
    /// - Parameter row: row to search for.
    open func indexOfRow(_ row: FoxScrollStackRow) -> Int? {
        return rows.firstIndex(of: row)
    }

    /// Set the insets of the row's content related to parent row cell.
    ///
    /// - Parameter row: target row.
    /// - Parameter insets: new insets.
    open func setRowInsets(index rowIndex: Int, insets: UIEdgeInsets) {
        safeRowAtIndex(rowIndex)?.rowInsets = insets
    }

    /// Set the insets of the row's content related to the parent row cell.
    ///
    /// - Parameter row: target rows.
    /// - Parameter insets: new insets.
    open func setRowsInsets(indexes rowIndexes: [Int], insets: UIEdgeInsets) {
        rowIndexes.forEach {
            setRowInsets(index: $0, insets: insets)
        }
    }

    /// Set the padding of the row's content related to parent row cell.
    ///
    /// - Parameter row: target row.
    /// - Parameter padding: new insets.
    open func setRowPadding(index rowIndex: Int, padding: UIEdgeInsets) {
        safeRowAtIndex(rowIndex)?.rowPadding = padding
    }

    /// Set the padding of the row's content related to the parent row cell.
    ///
    /// - Parameter row: target rows.
    /// - Parameter insets: new padding.
    open func setRowsPadding(indexes rowIndexes: [Int], padding: UIEdgeInsets) {
        rowIndexes.forEach {
            setRowPadding(index: $0, padding: padding)
        }
    }

    /// Return the visibility status of a row.
    ///
    /// - Parameter index: index of the row to check.
    open func isRowVisible(index: Int) -> RowVisibility {
        guard let row = safeRowAtIndex(index), row.isHidden == false else {
            return .hidden
        }

        return rowVisibilityType(row: row)
    }

    /// Return `true` if row is currently hidden.
    ///
    /// - Parameter row: row to check.
    open func isRowHidden(index: Int) -> Bool {
        return safeRowAtIndex(index)?.isHidden ?? false
    }

    // MARK: - Scroll

    /// Scroll to the passed row.
    ///
    /// - Parameter rowIndex: index of the row to make visible.
    /// - Parameter location: visibility of the row, location of the center point.
    /// - Parameter animated: `true` to perform animated transition.
    open func scrollToRow(index rowIndex: Int, at position: ScrollPosition = .automatic, animated: Bool = true) {
        guard let row = safeRowAtIndex(rowIndex) else {
            return
        }

        let rowFrame = convert(row.frame, to: self)

        if case .automatic = position {
            scrollRectToVisible(rowFrame, animated: animated)
            return
        }

        let offset = adjustedOffsetForFrame(rowFrame, toScrollAt: position)
        setContentOffset(offset, animated: animated)
    }

    /// Invert axis of scroll.
    ///
    /// - Parameter animated: `true` to animate operation.
    /// - Parameter completion: completion callback.
    open func toggleAxis(animated: Bool = false, completion: (() -> Void)? = nil) {
        UIView.execute(animated: animated, {
            self.axis = (self.axis == .horizontal ? .vertical : .horizontal)
        }, completion: completion)
    }

    // MARK: - Private Functions

    private func doReplaceRow(index sourceIndex: Int, createRow handler: @escaping ((Int, Bool) -> FoxScrollStackRow), animated: Bool, completion: (() -> Void)? = nil) {
        guard sourceIndex >= 0, sourceIndex < rows.count else {
            return
        }

        let sourceRow = rows[sourceIndex]
        guard animated else {
            removeRowFromStackView(sourceRow, animated: false)
            _ = handler(sourceIndex, false)
            completion?()
            return
        }

        stackView.setNeedsLayout()

        UIView.execute {
            sourceRow.isHidden = true
        } completion: { [weak self] in
            guard let self else { return }
            self.removeRowFromStackView(sourceRow, animated: false)
            let newRow = handler(sourceIndex, false)
            newRow.isHidden = true
            UIView.execute({
                newRow.isHidden = false
            }, completion: completion)
        }
    }

    /// Enumerate items to insert into the correct order based upon the location of destination.
    ///
    /// - Parameters:
    ///   - list: list to enumerate.
    ///   - location: insert location.
    ///   - callback: callback to call on enumrate.
    private func enumerateItems<T>(_ list: [T], insertAt location: InsertLocation, callback: ((T) -> FoxScrollStackRow?)) -> [FoxScrollStackRow] {
        switch location {
            case .bottom:
                return list.compactMap(callback)

            case .top, .atIndex, .afterView, .beforeView, .after, .before:
                // Inserting at a fixed relative index repeatedly would reverse the list;
                // reverse before insert so the final order matches the input.
                return list.reversed().compactMap(callback).reversed()
        }
    }

    /// Return the destination index for passed location. `nil` if index is not valid.
    ///
    /// - Parameter location: location.
    private func indexForLocation(_ location: InsertLocation) -> Int? {
        switch location {
            case .top:
                return 0
            case .bottom:
                return rows.count
            case .atIndex(let index):
                guard index >= 0, index <= rows.count else {
                    return nil
                }
                return index
            case .afterView(let view):
                guard let index = rowForView(view)?.index else {
                    return nil
                }
                return ((index + 1) >= rows.count ? rows.count : (index + 1))
            case .beforeView(let view):
                guard let index = rowForView(view)?.index else {
                    return nil
                }
                return index
            case .after(let controller):
                guard let index = rowForController(controller)?.index else {
                    return nil
                }
                return ((index + 1) >= rows.count ? rows.count : (index + 1))
            case .before(let controller):
                guard let index = rowForController(controller)?.index else {
                    return nil
                }
                return index
        }
    }

    /// Initial configuration of the control.
    private func setupUI() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        // Create stack view and add it to the scrollView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        addSubview(stackView)

        // Configure constraints for stackview
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        didChangeAxis(axis)
    }

    /// Reload selected rows of the stackview.
    ///
    /// - Parameter rows: rows to reload.
    /// - Parameter animated: `true` to animate reload.
    /// - Parameter completion: completion callback to call at the end of the reload.
    private func reloadRows(_ rows: [FoxScrollStackRow], animated: Bool = false, completion: (() -> Void)? = nil) {
        guard rows.isEmpty == false else {
            return
        }

        rows.forEach {
            ($0.controller as? FoxScrollStackContainableController)?.reloadContentFormStackView(stackView: self, row: $0, animated: animated)
            $0.askForCutomizedSizeOfContentView(animated: animated)
        }

        UIView.execute({
            self.layoutIfNeeded()
        }, completion: completion)
    }

    /// Get the row at specified index; if index is invalid `nil` is returned.
    ///
    /// - Parameter index: index of the row to get.
    private func safeRowAtIndex(_ index: Int) -> FoxScrollStackRow? {
        return safeRowsAtIndexes([index]).first
    }

    /// Get the rows at specified indexes, invalid indexes are ignored.
    ///
    /// - Parameter indexes: indexes of the rows to get.
    private func safeRowsAtIndexes(_ indexes: [Int]) -> [FoxScrollStackRow] {
        return indexes.compactMap { index in
            guard index >= 0, index < rows.count else {
                return nil
            }
            return rows[index]
        }
    }

    /// Get the row visibility type for a specific row.
    ///
    /// - Parameter row: row to get.
    private func rowVisibilityType(row: FoxScrollStackRow) -> RowVisibility {
        let rowFrame = convert(row.frame, to: self)
        guard bounds.intersects(rowFrame) else {
            return .offscreen
        }

        if bounds.contains(rowFrame) {
            return .entire
        } else {
            let rowArea = rowFrame.width * rowFrame.height
            guard rowArea > 0 else {
                return .partial(percentage: 0)
            }
            let intersection = bounds.intersection(rowFrame)
            let intersectionPercentage = ((intersection.width * intersection.height) / rowArea) * 100
            return .partial(percentage: intersectionPercentage)
        }
    }

    /// Remove passed row from stack view.
    ///
    /// - Parameter row: row to remove.
    /// - Parameter animated: `true` to perform animated transition.
    @discardableResult
    private func removeRowFromStackView(_ row: FoxScrollStackRow?, animated: Bool = false) -> UIViewController? {
        guard let row else { return nil }

        // Animate visibility
        let removedController = row.controller
        animateCellVisibility(row, animated: animated, hide: true, completion: { [weak self] in
            guard let self else { return }

            self.onChangeRow?(row, true)

            row.removeFromStackView()

            // When removing a cell the cell above is the only cell whose separator visibility
            // will be affected, so we need to update its visibility.
            self.updateRowsSeparatorVisibility()

            // Remove from the status
            self.prevVisibilityState.removeValue(forKey: row)
        })

        return removedController
    }

    /// Create a new row to handle passed view and insert it at specified index.
    ///
    /// - Parameters:
    ///   - view: view to use as `contentView` of the row.
    ///   - index: position of the new row with controller's view.
    ///   - animated: `true` to animate transition.
    ///   - completion:  completion callback called when operation is finished.
    @discardableResult
    private func createRowForView(_ view: UIView, insertAt index: Int, animated: Bool, completion: (() -> Void)? = nil) -> FoxScrollStackRow {
        // Identify any other cell with the same controller
        let cellToRemove = rowForView(view)?.cell

        // Create the new container cell for this view.
        let newRow = FoxScrollStackRow(view: view, stackView: self)
        return createRow(newRow, at: index, cellToRemove: cellToRemove, animated: animated, completion: completion)
    }

    /// Create a new row to handle passed controller and insert it at specified index.
    ///
    /// - Parameter controller: controller to manage.
    /// - Parameter index: position of the new row with controller's view.
    /// - Parameter animated: `true` to animate transition.
    /// - Parameter completion: completion callback called when operation is finished.
    @discardableResult
    private func createRowForController(_ controller: UIViewController, insertAt index: Int, animated: Bool, completion: (() -> Void)? = nil) -> FoxScrollStackRow {
        // Identify any other cell with the same controller to remove
        let cellToRemove = rowForController(controller)?.cell

        // Create the new container cell for this controller's view
        let newRow = FoxScrollStackRow(controller: controller, stackView: self)
        return createRow(newRow, at: index, cellToRemove: cellToRemove, animated: animated, completion: completion)
    }

    private var rowVisibilityChangesDispatchWorkItem: DispatchWorkItem?

    /// Private implementation to add new row.
    private func createRow(_ newRow: FoxScrollStackRow,
                           at index: Int,
                           cellToRemove: FoxScrollStackRow?,
                           animated: Bool,
                           completion: (() -> Void)? = nil) -> FoxScrollStackRow {
        onChangeRow?(newRow, false)
        stackView.insertArrangedSubview(newRow, at: index)

        // Remove any duplicate cell with the same view
        removeRowFromStackView(cellToRemove)

        postInsertRow(newRow, animated: animated, completion: completion)

        if animated {
            UIView.execute {
                self.layoutIfNeeded()
            }
        }

        if rowVisibilityChangesDispatchWorkItem == nil {
            rowVisibilityChangesDispatchWorkItem = DispatchWorkItem(block: { [weak self] in
                if let stackDelegate = self?.stackDelegate {
                    self?.dispatchRowsVisibilityChangesTo(stackDelegate)
                }

                self?.rowVisibilityChangesDispatchWorkItem = nil
            })

            /// Schedule a single `dispatchRowsVisibilityChangesTo(_:)` call.
            ///
            /// In this way, when rows are created inside a for-loop, the delegate is called only once after the `ScrollStack` has been fully laid out.
            DispatchQueue.main.async(execute: rowVisibilityChangesDispatchWorkItem!)
        }

        return newRow
    }

    private func postInsertRow(_ row: FoxScrollStackRow, animated: Bool, completion: (() -> Void)? = nil) {
        updateRowsSeparatorVisibility() // update visibility of the separators
        animateCellVisibility(row, animated: animated, hide: false, completion: completion) // Animate visibility of the cell
    }

    /// Update the separator visibility.
    private func updateRowsSeparatorVisibility() {
        let currentRows = rows
        for (idx, row) in currentRows.enumerated() {
            let isLastRow = idx == currentRows.count - 1
            if isLastRow && autoHideLastRowSeparator {
                row.separatorView.isHidden = true
            } else {
                row.separatorView.isHidden = row.isSeparatorHidden
            }
        }
    }

    private func applySeparatorHiddenToRows(_ hidden: Bool) {
        rows.forEach { row in
            row.isSeparatorHidden = hidden
        }
        updateRowsSeparatorVisibility()
    }

    /// Return the row before a given row, if exists.
    ///
    /// - Parameter row: row to check.
    private func rowBeforeRow(_ row: FoxScrollStackRow) -> FoxScrollStackRow? {
        guard let index = stackView.arrangedSubviews.firstIndex(of: row), index > 0 else {
            return nil
        }
        return stackView.arrangedSubviews[index - 1] as? FoxScrollStackRow
    }

    // MARK: - Row Animated Transitions

    private func animateCellVisibility(_ cell: FoxScrollStackRow, animated: Bool, hide: Bool, completion: (() -> Void)? = nil) {
        if hide {
            animateCellToInvisibleState(cell, animated: animated, hide: hide, completion: completion)
        } else {
            animateCellToVisibleState(cell, animated: animated, hide: hide, completion: completion)
        }
    }

    /// Animate transition of the cell to visible state.
    private func animateCellToVisibleState(_ row: FoxScrollStackRow, animated: Bool, hide: Bool, completion: (() -> Void)? = nil) {
        guard animated else {
            row.alpha = 1.0
            row.isHidden = false
            completion?()
            return
        }

        row.alpha = 0.0
        row.isHidden = false
        layoutIfNeeded()
        UIView.execute({
            row.alpha = 1.0
        }, completion: completion)
    }

    /// Animate transition of the cell to invisibile state.
    private func animateCellToInvisibleState(_ row: FoxScrollStackRow, animated: Bool, hide: Bool, completion: (() -> Void)? = nil) {
        UIView.execute(animated: animated, {
            row.isHidden = true
        }, completion: completion)
    }

    // MARK: - Axis Change Events

    /// Update the constraint due to axis change of the stack view.
    ///
    /// - Parameter axis: new axis.
    private func didChangeAxis(_ axis: NSLayoutConstraint.Axis) {
        didUpdateStackViewAxisTo(axis)
        didReflectAxisChangeToRows(axis)
    }

    private func didUpdateStackViewAxisTo(_ axis: NSLayoutConstraint.Axis) {
        axisConstraint?.isActive = false
        switch axis {
            case .horizontal:
                axisConstraint = stackView.heightAnchor.constraint(equalTo: heightAnchor)
            case .vertical:
                axisConstraint = stackView.widthAnchor.constraint(equalTo: widthAnchor)
            @unknown default:
                break
        }

        rows.forEach {
            $0.layoutUI()
        }

        axisConstraint?.isActive = true
    }

    private func didReflectAxisChangeToRows(_ axis: NSLayoutConstraint.Axis) {
        rows.forEach {
            $0.separatorAxis = (axis == .horizontal ? .vertical : .horizontal)
        }
    }

    private func dispatchRowsVisibilityChangesTo(_ delegate: FoxScrollStackControllerDelegate) {
        rows.enumerated().forEach { idx, row in
            let current = isRowVisible(index: idx)
            let previous = prevVisibilityState[row]

            switch (previous, current) {
                case (.offscreen, .partial), // row will become visible
                    (.offscreen, .entire),
                    (nil, .entire),
                    (nil, .partial),
                    (.partial, .entire),
                    (.hidden, .partial),
                    (.hidden, .entire):
                    delegate.scrollStackRowDidBecomeVisible(self, row: row, index: idx, state: current)

                case (.partial, .offscreen), // row will become invisible
                    (.entire, .offscreen),
                    (.entire, .partial),
                    (.partial, .hidden),
                    (.entire, .hidden):
                    delegate.scrollStackRowDidBecomeHidden(self, row: row, index: idx, state: current)

                default:
                    break
            }

            // store previous state
            prevVisibilityState[row] = current
        }
    }

    // MARK: - Private Scroll

    private func adjustedOffsetForFrame(_ frame: CGRect, toScrollAt position: ScrollPosition) -> CGPoint {
        var adjustedPoint: CGPoint = frame.origin

        switch position {
            case .middle:
                if axis == .horizontal {
                    adjustedPoint.x = frame.origin.x - ((bounds.size.width - frame.size.width) / 2.0)
                } else {
                    adjustedPoint.y = frame.origin.y - ((bounds.size.height - frame.size.height) / 2.0)
                }

            case .final:
                if axis == .horizontal {
                    adjustedPoint.x = frame.origin.x - (bounds.size.width - frame.size.width)
                } else {
                    adjustedPoint.y = frame.origin.y - (bounds.size.height - frame.size.height)
                }

            case .initial:
                if axis == .horizontal {
                    adjustedPoint.x = frame.origin.x
                } else {
                    adjustedPoint.y = frame.origin.y
                }

            case .automatic:
                break
        }

        if axis == .horizontal {
            adjustedPoint.x = max(adjustedPoint.x, 0)

            let reachedOffsetx = adjustedPoint.x + self.bounds.size.width
            if reachedOffsetx > self.contentSize.width {
                adjustedPoint.x -= (reachedOffsetx - self.contentSize.width)
            }
        } else {
            adjustedPoint.y = max(adjustedPoint.y, 0)

            let reachedOffsetY = adjustedPoint.y + self.bounds.size.height
            if reachedOffsetY > self.contentSize.height {
                adjustedPoint.y -= (reachedOffsetY - self.contentSize.height)
            }
        }

        return adjustedPoint
    }

    // MARK: UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScroll?(scrollView)

        guard let stackDelegate else { return }

        stackDelegate.scrollStackDidScroll(self, offset: contentOffset)

        dispatchRowsVisibilityChangesTo(stackDelegate)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)

        guard let stackDelegate else { return }

        stackDelegate.scrollStackDidEndScrollingAnimation(self)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        guard let stackDelegate else { return }

        stackDelegate.scrollStackDidUpdateLayout(self)

        if cachedContentSize != self.contentSize {
            stackDelegate.scrollStackContentSizeDidChange(self, form: cachedContentSize, to: contentSize)
        }
        cachedContentSize = self.contentSize
    }

    private func updateScrollViewDelegateOwnership() {
        delegate = (stackDelegate != nil || scrollViewDelegate != nil) ? self : nil
    }
}
