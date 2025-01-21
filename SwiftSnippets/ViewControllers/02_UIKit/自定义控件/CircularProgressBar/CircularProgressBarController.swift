//
//  CircularProgressBarController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/21.
//

import UIKit

class CircularProgressBarController: UIViewController {
    @IBOutlet weak var circularProgressBar: CircularProgressBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }

    // MARK: - Actions

    @IBAction func sliderAction(_ sender: UISlider) {
        circularProgressBar.progress = CGFloat(sender.value)
    }
}
