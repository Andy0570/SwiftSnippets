//
//  ScrollStackDemoController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/11.
//

import UIKit

class ScrollStackDemoController: UIViewController {
    @IBOutlet private weak var contentView: UIView!

    private var stackController = FoxScrollStackViewController()
    private var stackView: FoxScrollStack {
        return stackController.scrollStack
    }

    private var tagsVC: TagsVC!
    private var welcomeVC: WelcomeVC!
    private var galleryVC: GalleryVC!
    private var pricingVC: PricingVC!
    private var notesVC: NotesVC!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        stackController.view.frame = contentView.bounds
        contentView.addSubview(stackController.view)

        stackView.stackDelegate = self

        tagsVC = TagsVC()
        tagsVC.delegate = self

        welcomeVC = WelcomeVC()
        galleryVC = GalleryVC()
        pricingVC = PricingVC()
        pricingVC.delegate = self
        notesVC = NotesVC()

        /*stackView.isSeparatorHidden = false
        stackView.separatorColor = .red
        stackView.separatorThickness = 3
        stackView.autoHideLastRowSeparator = true
        */

        /*
         Plain UIView example
         let plainView = UIView(frame: .zero)
         plainView.backgroundColor = .green
         plainView.heightAnchor.constraint(equalToConstant: 300).isActive = true
         stackView.addRow(view: plainView)
        */

        stackView.addRows(controllers: [welcomeVC, notesVC, tagsVC, galleryVC, pricingVC], animated: false)
    }

    // MARK: - Actions

    @IBAction func addNewRow(_ sender: Any) {
        let galleryVC = GalleryVC()
        stackView.scrollToTop()
        stackView.addRow(controller: galleryVC, at: .top, animated: true)
    }

    @IBAction func hideOrShowRandomRow(_ sender: Any) {
        // let randomRow = Int.random(in: 0..<stackView.rows.count)
        let newRowStatus = !stackView.rows[0].isHidden
        stackView.setRowHidden(index: 0, isHidden: newRowStatus, animated: true)
    }

    @IBAction func toggleAxis(_ sender: Any) {
        stackView.toggleAxis(animated: false)
    }

    @IBAction func removeRow(_ sender: Any) {
        //  let randomRow = Int.random(in: 0..<stackView.rows.count)
          stackView.removeRow(index: 0, animated: true)
    }

    @IBAction func moveRowToRandom(_ sender: Any) {
        // let randomSrc = Int.random(in: 0..<stackView.rows.count)
         let randomDst = Int.random(in: 1..<stackView.rows.count)
         stackView.moveRow(index: 0, to: randomDst, animated: true, completion: nil)
    }

    @IBAction func scrollToRandom(_ sender: Any) {
        let randomRow = Int.random(in: 0..<stackView.rows.count)
        stackView.scrollToRow(index: randomRow, at: .middle, animated: true)
    }
}

extension ScrollStackDemoController: FoxScrollStackControllerDelegate {
    /// Tells the delegate when the user scrolls the content view within the receiver.
    ///
    /// - Parameter stackView: target stack view.
    /// - Parameter offset: current scroll offset.
    func scrollStackDidScroll(_ stackView: FoxScrollStack, offset: CGPoint) {
    }

    /// Tells the delegate when a scrolling animation in the scroll view concludes.
    ///
    /// - Parameter stackView: The ScrollStack object that’s performing the scrolling animation.
    func scrollStackDidEndScrollingAnimation(_ stackView: FoxScrollStack) {
    }

    /// Row did become partially or entirely visible.
    ///
    /// - Parameter row: target row.
    /// - Parameter index: index of the row.
    /// - Parameter state: state of the row.
    func scrollStackRowDidBecomeVisible(_ stackView: FoxScrollStack, row: FoxScrollStackRow, index: Int, state: FoxScrollStack.RowVisibility) {
    }

    /// Row did become partially or entirely invisible.
    ///
    /// - Parameter row: target row.
    /// - Parameter index: index of the row.
    /// - Parameter state: state of the row.
    func scrollStackRowDidBecomeHidden(_ stackView: FoxScrollStack, row: FoxScrollStackRow, index: Int, state: FoxScrollStack.RowVisibility) {
    }

    /// This function is called when layout is updated (added, removed, hide or show one or more rows).
    /// - Parameter stackView: target stack view.
    func scrollStackDidUpdateLayout(_ stackView: FoxScrollStack) {
        debugPrint("New content insets \(stackView.contentSize.height)")
    }

    /// This function is called when content size of the stack did change (remove/add, hide/show rows).
    ///
    /// - Parameters:
    ///   - stackView: target stack view
    ///   - oldValue: old content size.
    ///   - newValue: new content size.
    func scrollStackContentSizeDidChange(_ stackView: FoxScrollStack, form oldValue: CGSize, to newValue: CGSize) {
    }
}

extension ScrollStackDemoController: TagsVCProtocol {
    func toggleTags() {
        let index = stackView.rowForController(tagsVC)!.index
        tagsVC.isExpanded.toggle()
        stackView.reloadRow(index: index, animated: true)
    }
}

extension ScrollStackDemoController: PricingVCProtocol {
    func addFee() {
        printLog("⭐️⭐️⭐️ addFee")
        let otherFee = PricingTag(title: "Another fee", subtitle: "Some spare taxes", price: "$50.00")
        pricingVC.addFee(otherFee)
        let index = stackView.rowForController(pricingVC)!.index
        stackView.reloadRow(index: index, animated: true)
    }
}
