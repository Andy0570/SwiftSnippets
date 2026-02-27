//
//  RTVideoCollectionViewCell.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/2/27.
//

import UIKit

class RTVideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    var video: RTVideo? {
        didSet {
            thumbnailView.image = video?.thumbnail
            titleLabel.text = video?.title
            subtitleLabel.text = "\(video?.lessonCount ?? 0) lessons"
        }
    }
}
