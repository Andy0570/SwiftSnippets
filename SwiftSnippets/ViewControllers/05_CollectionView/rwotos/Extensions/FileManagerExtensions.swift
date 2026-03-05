//
//  FileManagerExtensions.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/4.
//

import Foundation

extension FileManager {
    /// 读取所有相册文件夹
    func albumsAtURL(_ fileURL: URL) throws -> [RWAlbumItem] {
        let albumsArray = try self.contentsOfDirectory(
            at: fileURL,
            includingPropertiesForKeys: [.nameKey, .isDirectoryKey],
            options: .skipsHiddenFiles
        ).filter { url -> Bool in // 过滤，只保留文件夹
            do {
                let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
                return resourceValues.isDirectory! && url.lastPathComponent.first != "_"
            } catch {
                return false
            }
        }.sorted(by: { urlA, urlB -> Bool in // 排序，按文件夹名字升序排序（字母排序）
            do {
                let nameA = try urlA.resourceValues(forKeys: [.nameKey]).name
                let nameB = try urlB.resourceValues(forKeys: [.nameKey]).name
                return nameA! < nameB!
            } catch {
                return true
            }
        })

        return albumsArray.map { fileURL -> RWAlbumItem in
            do {
                let detailItems = try self.albumDetailItemsAtURL(fileURL)
                return RWAlbumItem(albumURL: fileURL, imageItems: detailItems)
            } catch {
                return RWAlbumItem(albumURL: fileURL)
            }
        }
    }

    /// 读取某个相册里的所有图片
    func albumDetailItemsAtURL(_ fileURL: URL) throws -> [RWAlbumDetailItem] {
        guard let components = URLComponents(url: fileURL, resolvingAgainstBaseURL: false) else {
            return []
        }

        let photosArray = try self.contentsOfDirectory(
            at: fileURL,
            includingPropertiesForKeys: [.nameKey, .isDirectoryKey],
            options: .skipsHiddenFiles
        ).filter { url -> Bool in
            do {
                let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
                return !resourceValues.isDirectory! // 过滤，只保留文件（非目录）
            } catch {
                return false
            }
        }.sorted(by: { urlA, urlB -> Bool in // 排序，按文件名字母顺序排列
            do {
                let nameA = try urlA.resourceValues(forKeys: [.nameKey]).name
                let nameB = try urlB.resourceValues(forKeys: [.nameKey]).name
                return nameA! < nameB!
            } catch {
                return true
            }
        })

        return photosArray.map { fileURL in
//            let thumbnailURL = fileURL.deletingLastPathComponent()
//                .appendingPathComponent("thumbs")
//                .appendingPathComponent(fileURL.lastPathComponent)
            return RWAlbumDetailItem(photoURL: fileURL, thumbnailURL: URL(fileURLWithPath: "\(components.path)thumbs/\(fileURL.lastPathComponent)"))
        }
    }
}
