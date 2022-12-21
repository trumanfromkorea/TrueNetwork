//
//  URLRequest+.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/12/04.
//

import Foundation

extension URLRequest {
    func addBody(_ body: [String: Any]?) -> URLRequest {
        var request = self

        if let body,
           let bodyData = try? JSONSerialization.data(withJSONObject: body) {
            request.httpBody = bodyData
        }

        return request
    }

    func addHeaders(_ headers: [String: String]?) -> URLRequest {
        var request = self

        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
