//
//  FoxScrollStackSeparator.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/8.
//

import UIKit

public final class FoxScrollStackSeparator: UIView {
    internal init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentHuggingPriority(.defaultLow, for: .vertical)
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: thickness, height: thickness)
    }
    
    public var color: UIColor {
        get {
            return backgroundColor ?? .clear
        }
        set {
            backgroundColor = newValue
        }
    }
    
    public var thickness: CGFloat = 1 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
}
