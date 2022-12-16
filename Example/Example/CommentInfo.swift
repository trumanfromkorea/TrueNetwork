//
//  CommentInfo.swift
//  Example
//
//  Created by 장재훈 on 2022/12/16.
//

import Foundation

struct CommentInfo: Codable, CustomStringConvertible {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String

    var description: String {
        return """

        CommentInfo: {
            postId: \(postId)
            id: \(id)
            name: \(name)
            email: \(email)
            body: \(body)
        }

        """
    }
}
