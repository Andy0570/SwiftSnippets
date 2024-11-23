//
//  StringExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2022/9/7.
//

import Foundation
import CommonCrypto
import Security

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
                .map { $0.components(separatedBy: separator)}
                .flatMap { $0 }
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
}

/// 使用 DES、3DES、AES 算法进行对称加密和解密的扩展
/// 
/// 参考: <https://gist.github.com/tharindu/1cf0201492e41f1c287e51abb02902cd>
/// 参考: <https://github.com/krzyzanowskim/CryptoSwift>
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
        let keyData = key.data(using: String.Encoding.utf8)! as NSData // swiftlint:disable:this force_unwrapping
        let data = self.data(using: String.Encoding.utf8)! as NSData // swiftlint:disable:this force_unwrapping

        let cryptData = NSMutableData(length: Int(data.length) + blockSize)! // swiftlint:disable:this force_unwrapping

        let operation: CCOperation = UInt32(kCCEncrypt)

        var numBytesEncrypted: size_t = 0

        // swiftlint:disable indentation_width
        let cryptStatus = CCCrypt(operation,
                                  algorithm,
                                  UInt32(options),
                                  keyData.bytes, keyLength,
                                  nil,
                                  data.bytes, data.length,
                                  cryptData.mutableBytes, cryptData.length,
                                  &numBytesEncrypted)
        // swiftlint:enable indentation_width

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
            let cryptData    = NSMutableData(length: Int((data.length)) + blockSize) {
            let operation: CCOperation = UInt32(kCCDecrypt)
            var numBytesEncrypted: size_t = 0

            // swiftlint:disable indentation_width
            let cryptStatus = CCCrypt(operation,
                                      algorithm,
                                      UInt32(options),
                                      (keyData as NSData).bytes, keyLength,
                                      nil,
                                      data.bytes, data.length,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)
            // swiftlint:enable indentation_width

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
