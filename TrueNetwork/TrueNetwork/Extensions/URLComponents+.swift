//
//  URLComponents+.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/12/03.
//

import Foundation

extension URLComponents {
    mutating func addPaths(_ paths: [String]) {
        path = "\(paths.joined(separator: "/"))"
    }

    mutating func addParameters(_ parameters: [String: Any]?) {
        parameters?.forEach { key, value in
            let query = URLQueryItem(name: key, value: "\(value)")
            
            queryItems?.append(query)
        }
    }
}
