//
//  HTTPMethod.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/10/18.
//

import Foundation

/**
 요청에 사용되는 HTTPMethod 들의 case 입니다.
 */
public enum HTTPMethod {
    case get
    case post
    case delete
    case patch
    case put

    public var label: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .patch: return "PATCH"
        case .put: return "PUT"
        }
    }
}
