//
//  Photo.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/14.
//

import Foundation
import UIKit.UIImage

struct Photo {
    var caption: String
    var comment: String
    var image: UIImage

    init(caption: String, comment: String, image: UIImage) {
        self.caption = caption
        self.comment = comment
        self.image = image
    }

    init?(dictionary: [String: String]) {
        guard let caption = dictionary["Caption"],
              let comment = dictionary["Comment"],
              let photo = dictionary["Photo"],
              let image = UIImage(named: photo) else {
            return nil
        }

        self.init(caption: caption, comment: comment, image: image)
    }

    static func allPhotos() -> [Photo] {
        var photos: [Photo] = []
        guard let URL = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
              let photosFormPlist = NSArray(contentsOf: URL) as? [[String: String]] else {
            return photos
        }

        for dictionary in photosFormPlist {
            if let photo = Photo(dictionary: dictionary) {
                photos.append(photo)
            }
        }
        return photos
    }
}
