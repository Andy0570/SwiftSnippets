//
//  GalleryVC.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/10.
//

import UIKit

class GalleryVC: UIViewController {
    
    // MARK: - Control
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!

    public var urls: [URL] = [
        URL(string: "http://cdn.luxuo.com/2011/05/Aerial-view-luxury-Burj-Al-Arab.jpg")!,
        URL(string: "https://mediastream.jumeirah.com/webimage/heroactual//globalassets/global/hotels-and-resorts/dubai/burj-al-arab/rooms/new-royal-two-berdoom-suite/burj-al-arab-royal-suite-staircase-5-hero.jpg")!,
        URL(string: "https://mediastream.jumeirah.com/webimage/image1152x648//globalassets/global/hotels-and-resorts/dubai/burj-al-arab/rooms/new-sky-one-bedroom-suite/2019/burj-al-arab-jumeirah-sky-one-bedroom-suite-living-room-desktop.jpeg")!,
        URL(string: "https://q-xx.bstatic.com/xdata/images/hotel/max500/200178877.jpg?k=229a02237c3998ac6e8b11daae254113268e779e49ab2d18964f2e97bdc947a0&o=")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }
    
    private func reloadData() {
        pageControl.numberOfPages = urls.count
        collectionView.reloadData()
    }
    
    
    private func setupView() {
        view.backgroundColor = UIColor.systemBackground

        // collectionView
        
        // pageControl
        
    }
}

extension GalleryVC: FoxScrollStackContainableController {
    // 固定高度
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fixed(300)
    }
    
    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
        
    }
}

extension GalleryVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
}
