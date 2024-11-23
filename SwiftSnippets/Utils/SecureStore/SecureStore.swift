//
//  SecureStore.swift
//  SeaTao
//
//  Created by Qilin Hu on 2022/9/7.
//

import Foundation
import Security

/// 钥匙串服务（Keychain Services API）包装器
///
///     使用示例：
///     let genericPwdQueryable = GenericPasswordQueryable(service: "someService")
///     let secureStoreWithGenericPwd = SecureStore(secureStoreQueryable: genericPwdQueryable)
///     do {
///         try secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
///     } catch (let errow) {
///         XCTFail("Saving generic password failed with \(errow.localizedDescription).")
///     }
///
/// - SeeAlso: <https://www.raywenderlich.com/9240-keychain-services-api-tutorial-for-passwords-in-swift>
public struct SecureStore {
    let secureStoreQueryable: SecureStoreQueryable

    public init(secureStoreQueryable: SecureStoreQueryable) {
        self.secureStoreQueryable = secureStoreQueryable
    }

    /// 添加、更新密钥
    public func setValue(_ value: String, for userAccount: String) throws {
        // 1.检查是否可以将要存储的值编码为 Data 类型
        guard let encodedPassword = value.data(using: .utf8) else {
            throw SecureStoreError.string2DataConversionError
        }

        // 2.请求 secureStoreQueryable 实例执行查询，并附加要查询的账户
        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = userAccount

        // 3.搜索并返回与查询匹配的钥匙串项
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            // 4.查询成功，表明该账户的密码已存在，执行更新
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = encodedPassword

            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                throw error(from: status)
            }
        case errSecItemNotFound:
            // 5.找不到匹配项，表明该账户的密码不存在，执行添加
            query[String(kSecValueData)] = encodedPassword

            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw error(from: status)
            }
        default:
            throw error(from: status)
        }
    }

    /// 获取密钥
    public func getValue(for userAccount: String) throws -> String? {
        // 询问 secureStoreQueryable 以执行查询
        var query = secureStoreQueryable.query
        query[String(kSecMatchLimit)] = kSecMatchLimitOne // 返回单个结果
        query[String(kSecReturnAttributes)] = kCFBooleanTrue // 返回与该 item 关联的所有属性
        query[String(kSecReturnData)] = kCFBooleanTrue // 返回未加密数据
        query[String(kSecAttrAccount)] = userAccount

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }

        switch status {
        case errSecSuccess:
            guard let queriedItem = queryResult as? [String: Any],
                let passwordData = queriedItem[String(kSecValueData)] as? Data,
                let password = String(data: passwordData, encoding: .utf8) else {
                    throw SecureStoreError.data2StringConversionError
            }
            return password
        case errSecItemNotFound:
            return nil
        default:
            throw error(from: status)
        }
    }

    /// 删除指定账户密钥
    public func removeValue(for userAccount: String) throws {
        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = userAccount

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }

    /// 删除与特定服务相关的所有密钥
    public func removeAllValues() throws {
        let query = secureStoreQueryable.query

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }

    /// 返回值 OSStatus 是一个 32 位的有符号整数，可能的返回值类型如下：
    /// <https://developer.apple.com/documentation/security/1542001-security_framework_result_codes>
    /// 这里通过 SecCopyErrorMessageString(_:_:) 函数将其转化为人类可读字符串形式
    private func error(from status: OSStatus) -> SecureStoreError {
        let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        return SecureStoreError.unhandledError(message: message)
    }
}
