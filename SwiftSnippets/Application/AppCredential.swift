//
//  AppCredential.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2024/11/22.
//

import Foundation
import SwiftyJSON

/**
 应用授权凭证
 1. 从 Unsplash 获取应用授权凭证（access_key 和 secret_key）；
 2. 将应用授权凭证保存到项目根目录的 config.json 文件中；
 3. 通过该单例类获取对应字段并使用；

 - Attention: 请提前将从 [Unsplash](https://unsplash.com/developers) 获取到的应用授权凭证保存到项目根目录的 config.json 文件中。
 */
final class AppCredential {
    private let configFileName = "config"

    // 私有只读属性，该属性可以被外部读取，但不能写入
    private(set) var accessKey: String
    private(set) var secretKey: String

    init() {
        // 加载配置文件路径，否则返回文件未找到错误
        guard let configFilePath = Bundle.main.path(forResource: configFileName, ofType: "json") else {
            fatalError("Error: File Not Found.")
        }

        // 从指定路径中读取数据，否则返回文件不可读错误
        guard let data = FileManager.default.contents(atPath: configFilePath) else {
            fatalError("Error: File Unreadable.")
        }

        // 将数据转换为 JSON 字符串，否则返回编码错误
        do {
            // 使用 Data 数据创建一个 JSON 对象
            let json = try JSON(data: data)

            // If not a String or nil, return ""
            self.accessKey = json["api_keys"]["access_key"].stringValue
            self.secretKey = json["api_keys"]["secret_key"].stringValue

            if self.accessKey.isEmpty || self.secretKey.isEmpty {
                fatalError("Error: Empty value.")
            }
        } catch {
            fatalError("Error: File decoding Failed.")
        }
    }
}
