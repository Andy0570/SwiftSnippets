//
//  RWPhotoDetailViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/4.
//

import UIKit

class RWPhotoDetailViewController: UIViewController {
    var photoURL: URL?
    let imageView = UIImageView()

    convenience init(photoURL: URL) {
        self.init()
        self.photoURL = photoURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let photoURL {
            let imageName = photoURL.lastPathComponent
            navigationItem.title = imageName
            
            let image = UIImage(contentsOfFile: photoURL.path)
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            view.backgroundColor = .systemBackground
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                imageView.topAnchor.constraint(equalTo: view.topAnchor)
            ])
        }
    }
}
