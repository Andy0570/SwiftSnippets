//
//  HTTPClient.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/12/12.
//

import Foundation
import UIKit.UIImage

// 模拟远程网络请求
class HTTPClient {
    @discardableResult
    func getRequest(_ url: String) -> AnyObject {
        return Data() as AnyObject
    }

    @discardableResult
    func postRequest(_ url: String, body: String) -> AnyObject {
        return Data() as AnyObject
    }

    // 通过 url 下载图片
    func downloadImage(_ url: String) -> UIImage? {
        guard let aURL = URL(string: url),
              let data = try? Data(contentsOf: aURL),
              let image = UIImage(data: data) else {
            return nil
        }

        return image
    }
}
