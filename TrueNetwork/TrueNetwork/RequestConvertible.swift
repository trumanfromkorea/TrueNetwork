//
//  RequestConvertible.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/10/18.
//

import Foundation

// API 규격 프로토콜
public protocol RequestConvertible {
    var baseUrl: String { get }
    var method: HTTPMethod { get }
    var paths: [String] { get }
    var parameters: [String: Any]? { get }
    var body: [String: Any]? { get }
    var headers: [String: String]? { get }
}

