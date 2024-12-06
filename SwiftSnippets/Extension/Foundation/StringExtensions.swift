//
//  StringExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2022/9/7.
//

import Foundation
import UIKit
import CoreLocation
import CommonCrypto
import Security
import CryptoKit
import SwifterSwift

extension String {
    /// 使用多个分隔符快速拆分字符串
    ///
    /// - Parameter separators: 包含分隔符的数组
    /// - Returns: 拆分后的字符串数组
    /// - SeeAlso: <https://stackoverflow.com/questions/32465121/splitting-a-string-in-swift-using-multiple-delimiters>
    func components(separatedBy separators: [String]) -> [String] {
        var result = [self]
        for separator in separators {
            result = result
                .map { $0.components(separatedBy: separator) }
                .flatMap { $0 }
        }
        return result
    }

    /// 格式化字符串，在原始字符串的基础上，每隔 interval 个字符插入特定字符
    ///
    ///     var cardNumber = "1234567890123456"
    ///     cardNumber.insert(separator: " ", every: 4)
    ///     // 1234 5678 9012 3456
    ///
    ///     let pin = "7690"
    ///     let pinWithDashes = pin.inserting(separator: "-", every: 1)
    ///     // 7-6-9-0
    ///
    /// - SeeAlso: <https://betterprogramming.pub/10-useful-swift-string-extensions-e4280e55a554>
    mutating func insert(separator: String, every interval: Int) {
        self = inserting(separator: separator, every: interval)
    }

    func inserting(separator: String, every interval: Int) -> String {
        var result: String = ""
        let characters = Array(self)
        stride(from: 0, to: count, by: interval).forEach {
            result += String(characters[$0..<min($0 + interval, count)])
            if $0 + interval < count {
                result += separator
            }
        }
        return result
    }

    /// 替换 URL 的 scheme 协议
    func urlScheme(_ scheme: String) -> URL? {
        guard let url = URL(string: self) else {
            return nil
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.scheme = scheme
        return components?.url
    }

    /// 从给定字符串中检索有效 URL
    ///
    ///     let unfilteredString = "To get the best search results, go to https://www.google.com, www.duckduckgo.com, or www.bing.com"
    ///     let urls = unfilteredString.getURLs()
    ///     
    /// - Returns: 包含有效 URL 的数组
    /// - SeeAlso: <https://medium.com/livefront/10-swift-extensions-we-use-at-livefront-8b84de32f77b>
    func getURLs() -> [URL] {
        var foundUrls: [URL] = []
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return foundUrls
        }

        let matches = detector.matches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: self.utf16.count)
        )

        for match in matches {
            guard let range = Range(match.range, in: self),
                let retrievedURL = URL(string: String(self[range])) else { continue }
            foundUrls.append(retrievedURL)
        }

        return foundUrls
    }

    /// 计算字符串的 MD5 哈希值
    /// - Requires: CryptoKit
    var md5: String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

    /// 将 json string 类型转换为 Dictionary 类型
    ///
    ///     let json = "{\"hello\": \"world\"}"
    ///     let dictFromJSON = json.asDictionary
    ///
    /// - SeeAlso: <https://betterprogramming.pub/24-swift-extensions-for-cleaner-code-41e250c9c4c3>
    var asDictionary: [String: Any]? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
    }

    /// 将 json 数组转换为 Array 数组
    ///
    ///     let json = "[1, 2, 3]"
    ///     let arrayFromJSON = json.asArray
    ///
    /// - SeeAlso: <https://betterprogramming.pub/24-swift-extensions-for-cleaner-code-41e250c9c4c3>
    var asArray: [Any]? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any]
    }

    /// 将 HTML 格式的字符串转换为 NSAttributedString
    ///
    ///     let htmlString = "<p>Hello, <strong>world!</string></p>"
    ///     let attrString = htmlString.asAttributedString
    ///
    /// - SeeAlso: <https://betterprogramming.pub/24-swift-extensions-for-cleaner-code-41e250c9c4c3>
    var asAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        return try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
    }

    /// 将字符串形式的经纬度坐标转化为 CLLocationCoordinate2D 形式
    ///
    ///     let strCoordinates = "41.6168, 41.6367"
    ///     let coordinates = strCoordinates.asCoordinates
    ///
    /// - Requires: CoreLocation、SwifterSwift
    /// - SeeAlso: <https://betterprogramming.pub/24-swift-extensions-for-cleaner-code-41e250c9c4c3>
    var asCoordinates: CLLocationCoordinate2D? {
        let components = self.components(separatedBy: ",")
        guard components.count == 2 else {
            return nil
        }

        let strLat = components[0].trimmed
        let strLng = components[1].trimmed
        guard let lat = Double(strLat), let lng = Double(strLng) else {
            return nil
        }

        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}

// MARK: -

/// 使用提供的 UIFont 来计算字符串的宽度和高度
///
///     let text = "Hello, world!"
///     let textHeight = text.height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 16))
///
/// - Requires: UIKit
/// - SeeAlso: <https://betterprogramming.pub/24-swift-extensions-for-cleaner-code-41e250c9c4c3>
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.width)
    }
}

// MARK: - Algorithm

/// 使用 DES、3DES、AES 算法进行对称加密和解密的扩展
///
/// - Requires: CommonCrypto、Security
/// - SeeAlso: <https://gist.github.com/tharindu/1cf0201492e41f1c287e51abb02902cd>
/// - SeeAlso: <https://github.com/krzyzanowskim/CryptoSwift>
extension String {
    /// Encrypts message with DES algorithm
    func desEncrypt(key: String) -> String? {
        return symetricEncrypt(key: key, blockSize: kCCBlockSizeDES, keyLength: size_t(kCCKeySizeDES), algorithm: UInt32(kCCAlgorithmDES))
    }

    /// Encrypts message with 3DES algorithm
    func tripleDesEncrypt(key: String) -> String? {
        return symetricEncrypt(key: key, blockSize: kCCBlockSize3DES, keyLength: size_t(kCCKeySize3DES), algorithm: UInt32(kCCAlgorithm3DES))
    }

    /// Encrypts message with AES 128 algorithm
    func aes128Encrypt(key: String) -> String? {
        return symetricEncrypt(key: key, blockSize: kCCBlockSizeAES128, keyLength: size_t(kCCKeySizeAES128), algorithm: UInt32(kCCAlgorithmAES128))
    }

    /// Encrypts message with AES algorithm with 256 key length
    func aesEncrypt(key: String) -> String? {
        return symetricEncrypt(key: key, blockSize: kCCBlockSizeAES128, keyLength: size_t(kCCKeySizeAES256), algorithm: UInt32(kCCAlgorithmAES))
    }

    /// Encrypts a message with symmetric algorithm
    func symetricEncrypt(key: String, blockSize: Int, keyLength: size_t, algorithm: CCAlgorithm, options: Int = kCCOptionPKCS7Padding) -> String? {
        // swiftlint:disable force_unwrapping
        let keyData = key.data(using: String.Encoding.utf8)! as NSData
        let data = self.data(using: String.Encoding.utf8)! as NSData
        let cryptData = NSMutableData(length: Int(data.length) + blockSize)!
        // swiftlint:enable force_unwrapping
        let operation: CCOperation = UInt32(kCCEncrypt)
        var numBytesEncrypted: size_t = 0

        let cryptStatus = CCCrypt(
            operation,
            algorithm,
            UInt32(options),
            keyData.bytes,
            keyLength,
            nil,
            data.bytes,
            data.length,
            cryptData.mutableBytes,
            cryptData.length,
            &numBytesEncrypted
        )

        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.length = Int(numBytesEncrypted)
            let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
            return base64cryptString
        } else {
            return nil
        }
    }

    /// Decrypts message with DES algorithm
    func desDecrypt(key: String) -> String? {
        return symetricDecrypt(key: key, blockSize: kCCBlockSizeDES, keyLength: size_t(kCCKeySizeDES), algorithm: UInt32(kCCAlgorithmDES))
    }

    /// Decrypts message with 3DES algorithm
    func tripleDesDecrypt(key: String) -> String? {
        return symetricDecrypt(key: key, blockSize: kCCBlockSize3DES, keyLength: size_t(kCCKeySize3DES), algorithm: UInt32(kCCAlgorithm3DES))
    }

    /// Decrypts message with AES 128 algorithm
    func aes128Decrypt(key: String) -> String? {
        return symetricDecrypt(key: key, blockSize: kCCBlockSizeAES128, keyLength: size_t(kCCKeySizeAES128), algorithm: UInt32(kCCAlgorithmAES128))
    }

    /// Decrypts message with AES algorithm with 256 key length
    func aesDecrypt(key: String) -> String? {
        return symetricDecrypt(key: key, blockSize: kCCBlockSizeAES128, keyLength: size_t(kCCKeySizeAES256), algorithm: UInt32(kCCAlgorithmAES))
    }

    /// Decrypts a message with symmetric algorithm
    func symetricDecrypt(key: String, blockSize: Int, keyLength: size_t, algorithm: CCAlgorithm, options: Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
            let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
            let cryptData = NSMutableData(length: Int((data.length)) + blockSize) {
            let operation: CCOperation = UInt32(kCCDecrypt)
            var numBytesEncrypted: size_t = 0

            let cryptStatus = CCCrypt(
                operation,
                algorithm,
                UInt32(options),
                (keyData as NSData).bytes,
                keyLength,
                nil,
                data.bytes,
                data.length,
                cryptData.mutableBytes,
                cryptData.length,
                &numBytesEncrypted
            )

            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let unencryptedMessage = String(data: cryptData as Data, encoding: String.Encoding.utf8)
                return unencryptedMessage
            } else {
                return nil
            }
        }
        return nil
    }
}
