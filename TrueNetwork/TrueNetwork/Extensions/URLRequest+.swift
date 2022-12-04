//
//  URLRequest+.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/12/04.
//

import Foundation

extension URLRequest {
    mutating func addBody(_ body: [String: Any]?) {
        guard let body,
              let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            return
        }
        httpBody = bodyData
    }

    mutating func addHeaders(_ headers: [String: String]?) {
        headers?.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }
    }
}
