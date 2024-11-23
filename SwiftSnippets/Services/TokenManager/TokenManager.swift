//
//  TokenManager.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/5/10.
//

import Foundation

/// 将 Access Token 保存到钥匙串
final class TokenManager {
    static let shared = TokenManager()
    let userAccount = "accessToken"

    private init() {} // 防止其他对象使用这个类的默认 '()' 初始化器。

    private let secureStore: SecureStore = {
        let accessTokenQueryable = GenericPasswordQueryable(service: "SeaTaoService")
        return SecureStore(secureStoreQueryable: accessTokenQueryable)
    }()

    func saveAccessToken(token: AuthCredential) {
        do {
            try secureStore.setValue(token.accessToken, for: userAccount)
        } catch {
            print("Error saving access token: \(error)")
        }
    }

    func fetchAccessToken() -> String? {
        do {
            return try secureStore.getValue(for: userAccount)
        } catch {
            print("Error fetching access token: \(error)")
        }
        return nil
    }
}
