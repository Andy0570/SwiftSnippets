//
//  NotesVC.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/10.
//

import UIKit

class NotesVC: UIViewController {
    
    // MARK: - Controls
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var textView: UITextView!
    
    private var textViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        view.height(constant: nil)
        textView.isScrollEnabled = false
        textView.delegate = self
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.systemBackground
        
        // titleLabel
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .natural
        titleLabel.textColor = UIColor.label
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.text = "Notes"
        view.addSubview(titleLabel)
        
        // subTitleLabel
        subTitleLabel = UILabel(frame: .zero)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.textAlignment = .natural
        subTitleLabel.textColor = UIColor.secondaryLabel
        subTitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subTitleLabel.text = "Growing UIViewController with UITextView"
        view.addSubview(subTitleLabel)
        
        // textView
        textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.label
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.text = "Please input text..."
        textView.backgroundColor = UIColor.lightGray
        view.addSubview(textView)
        
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 245)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            textViewHeightConstraint
        ])
    }
    
    override func updateViewConstraints() {
        // 手动计算 textView 的高度
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        self.textViewHeightConstraint.constant = newSize.height
        
        view.height(constant: nil)
        super.updateViewConstraints()
    }
}

extension NotesVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateViewConstraints()
    }
}

extension NotesVC: FoxScrollStackContainableController {
    
    // 基于 UITextView 的内容自适应大小
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fitLayoutForAxis
    }
    
    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
        
    }
}
