//
//  AuthCredential.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/5/10.
//

import Foundation

/**
 用户登录成功，返回访问授权信息

 Example:
 {
     "access_token": "2e1f24fd-6fe4-48e4-88ea-5411ba8a7adc",
     "token_type": "bearer",
     "refresh_token": "cfcd31a9-1448-4d9e-9135-be02b0b3d5a6",
     "expires_in": 5273683,
     "scope": "app"
 }
 */
struct AuthCredential: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let scope: String
    let expressIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case scope
        case expressIn = "expires_in"
    }
}
