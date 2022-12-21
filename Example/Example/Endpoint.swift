//
//  Endpoint.swift
//  Example
//
//  Created by 장재훈 on 2022/12/07.
//

import Foundation
import TrueNetwork

enum Endpoint {
    case fetchPosts
    case fetchCommentsWithPath(postId: Int)
    case fetchCommentsWithParams(postId: Int)
    case writePost(post: PostInfo)
    case updatePost(postId: Int, post: PostInfo)
    case updateTitle(postId: Int, title: String)
    case deletePost(postId: Int)
}

extension Endpoint: RequestConvertible {
    var baseUrl: String {
        return "https://jsonplaceholder.typicode.com"
    }

    var method: HTTPMethod {
        switch self {
        case .fetchPosts, .fetchCommentsWithPath, .fetchCommentsWithParams:
            return .get

        case .writePost:
            return .post

        case .updatePost:
            return .put

        case .updateTitle:
            return .patch

        case .deletePost:
            return .delete
        }
    }

    var paths: [String] {
        switch self {
        case .fetchPosts:
            return ["posts"]

        case let .fetchCommentsWithPath(postId):
            return ["posts", "\(postId)", "comments"]

        case .fetchCommentsWithParams:
            return ["comments"]

        case .writePost:
            return ["posts"]

        case let .updatePost(postId, _):
            return ["posts", "\(postId)"]

        case let .updateTitle(postId, _):
            return ["posts", "\(postId)"]

        case let .deletePost(postId):
            return ["posts", "\(postId)"]
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case let .fetchCommentsWithParams(postId):
            return ["postId": postId]

        default:
            return nil
        }
    }

    var body: [String: Any]? {
        switch self {
        case let .writePost(post):
            return post.dict

        case let .updatePost(_, post):
            return post.dict

        case let .updateTitle(_, title):
            return ["title": title]

        default:
            return nil
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json; charset=UTF-8"]
    }
}
