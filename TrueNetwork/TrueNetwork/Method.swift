//
//  Method.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/10/18.
//

import Foundation

// HTTPMethod 케이스
public enum Method {
    case get
    case post
    case delete

    public var label: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .delete: return "DELETE"
        }
    }
}
