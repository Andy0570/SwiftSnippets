//
//  FoxScrollStackViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/8.
//

import UIKit

open class FoxScrollStackViewController: UIViewController {
    
    // MARK: Public Properties
    
    /// Inner stack view control.
    public let scrollStack = FoxScrollStack()
    
    /// Displays the scroll indicators momentarily.
    open var automaticallyFlashScrollIndicators = false
    
    // MARK: Init
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: View Lifecycle
    
    open override func loadView() {
        view = scrollStack
        // monitor remove or add of a row to manage the view controller's hierarchy
        scrollStack.onChangeRow = { [weak self] (row, isRemoved) in
            guard let self else { return }
            self.didAddOrRemoveRow(row, isRemoved: isRemoved)
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if automaticallyFlashScrollIndicators {
            scrollStack.flashScrollIndicators()
        }
    }
    
    // MARK: - Private Functions
    
    private func didAddOrRemoveRow(_ row: FoxScrollStackRow, isRemoved: Bool) {
        guard let controller = row.controller else {
            return
        }
        
        if isRemoved {
            controller.removeFromParent()
            controller.didMove(toParent: nil)
        } else {
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
    }
}
