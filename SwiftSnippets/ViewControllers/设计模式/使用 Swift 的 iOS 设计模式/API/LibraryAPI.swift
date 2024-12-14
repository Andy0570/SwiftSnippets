//
//  LibraryAPI.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/12/12.
//

import Foundation
import UIKit.UIImageView

// MARK: 单例模式
// 确保给定类只会存在一个实例，并且该实例只有一个全局的访问点。

final class LibraryAPI {
    static let shared = LibraryAPI()

    // 将初始化方法标记为 private 可以防止其他对象使用这个类的默认 '()' 初始化器。
    private init() {
        // 通知的订阅者/观察者
        // 每次 AlbumView 发送 BLDownloadImage 通知时，由于 LibraryAPI 已注册为该通知的观察者，
        // 系统会通知 LibraryAPI，然后 LibraryAPI 响应并调用 downloadImage(with:) 方法
        NotificationCenter.default.addObserver(self, selector: #selector(downloadImage(with:)), name: .BLDownloadImage, object: nil)
    }

    // MARK: 外观（Facade）模式
    // 为复杂子系统提供单一接口，你只需要公开一个简单而统一的 API，而不是将一组类及其 API 暴露给用户。
    private let persistencyManager = PersistencyManager()
    private let httpClient = HTTPClient()
    // 是否将对应专辑列表所做的更新同步到远程服务器，用于模拟服务是否在线，因此该值在这里始终为 false
    private let isOnline = false

    func getAlbums() -> [Album] {
        return persistencyManager.getAlbums()
    }

    func addAlbum(_ album: Album, at index: Int) {
        persistencyManager.addAlbum(album, at: index)
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: album.description)
        }
    }

    func deleteAlbum(at index: Int) {
        persistencyManager.deleteAlbum(at: index)
        if isOnline {
            httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }

    // MARK: - 通知

    @objc func downloadImage(with notification: Notification) {
        guard let userInfo = notification.userInfo,
              let imageView = userInfo["imageView"] as? UIImageView,
              let coverUrl = userInfo["coverUrl"] as? String,
              let filename = URL(string: coverUrl)?.lastPathComponent else {
            return
        }

        // 尝试从本地缓存中获取图片
        if let savedImage = persistencyManager.getImage(with: filename) {
            imageView.image = savedImage
            return
        }

        // 使用 HTTPClient 下载图片
        DispatchQueue.global().async {
            guard let downloadedImage = self.httpClient.downloadImage(coverUrl) else {
                return
            }

            // 下载完成后，显示并缓存图片
            DispatchQueue.main.async {
                imageView.image = downloadedImage
                self.persistencyManager.saveImage(downloadedImage, filename: filename)
            }
        }
    }
}
