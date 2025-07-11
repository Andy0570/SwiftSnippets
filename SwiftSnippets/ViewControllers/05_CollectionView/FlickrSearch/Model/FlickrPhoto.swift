//
//  FlickrPhoto.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/7/10.
//

import Foundation
import UIKit.UIImage

class FlickrPhoto: Equatable {
    var thumbnail: UIImage?
    var largeImage: UIImage?
    let photoID: String
    let farm: Int
    let server: String
    let secret: String

    init(photoID: String, farm: Int, server: String, secret: String) {
        self.photoID = photoID
        self.farm = farm
        self.server = server
        self.secret = secret
    }

    func flickrImageURL(_ size: String = "m") -> URL? {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg")
    }

    enum Error: Swift.Error {
        case invalidURL
        case noData
    }

    func loadLargeImage(_ completion: @escaping (Result<FlickrPhoto, Swift.Error>) -> Void) {
        guard let loadURL = flickrImageURL("b") else {
            DispatchQueue.main.async {
                completion(.failure(Error.invalidURL))
            }
            return
        }

        let loadRequest = URLRequest(url: loadURL)

        URLSession.shared.dataTask(with: loadRequest) { data, _, error in
            DispatchQueue.main.async {
                if let error {
                    completion(.failure(error))
                }

                guard let data else {
                    completion(.failure(Error.noData))
                    return
                }

                let returnedImage = UIImage(data: data)
                self.largeImage = returnedImage
                completion(.success(self))
            }
        }
        .resume()
    }

    /// 按宽度等比缩放图片尺寸‌。在保证图片不变形的前提下，优先填满宽度，当高度超出时自动切换为填满高度。
    func sizeToFillWidth(of size: CGSize) -> CGSize {
        guard let thumbnail else {
            return size
        }

        let imageSize = thumbnail.size
        var returnSize = size

        let aspectRatio = imageSize.width / imageSize.height

        returnSize.height = returnSize.width / aspectRatio

        if returnSize.height > size.height {
            returnSize.height = size.height
            returnSize.width = size.height * aspectRatio
        }

        return returnSize
    }

    // MARK: - Equatable

    static func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}
