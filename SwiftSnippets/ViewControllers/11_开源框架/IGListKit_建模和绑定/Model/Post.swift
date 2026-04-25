//
//  Post.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/11/24.
//

import IGListKit

final class Post: ListDiffable {
    let username: String
    let timestamp: String
    let imageURL: URL
    let likes: Int
    let comments: [Comment]

    init(username: String, timestamp: String, imageURL: URL, likes: Int, comments: [Comment]) {
        self.username = username
        self.timestamp = timestamp
        self.imageURL = imageURL
        self.likes = likes
        self.comments = comments
    }

    // MARK: - ListDiffable

    // 为每篇帖子生成一个唯一的标识符，在本示例中，基于帖子的「用户名+时间戳」的组合总是唯一的
    func diffIdentifier() -> any NSObjectProtocol {
        return (username + timestamp) as NSObjectProtocol
    }

    // 在本示例中，如果两篇帖子的 diffIdentifier 相同，那么他们一定相等
    func isEqual(toDiffableObject object: (any ListDiffable)?) -> Bool {
        return true
    }
}
