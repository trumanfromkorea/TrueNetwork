//
//  URLRequest+.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/12/04.
//

import Foundation

extension URLRequest {
    /**
     URLRequest 에 body 를 추가합니다.

     - Parameters:
        - paths: Body 요소를 담은 Dictionary 입니다.
     - Returns: 추가 성공 시 URLRequest 를, 실패 시 `nil` 을 리턴합니다.
     */
    func addBody(_ body: [String: Any]?) -> URLRequest {
        var request = self

        if let body,
           let bodyData = try? JSONSerialization.data(withJSONObject: body) {
            request.httpBody = bodyData
        }

        return request
    }

    /**
     URLRequest 에 header 를 추가합니다.

     - Parameters:
        - paths: Header 요소를 담은 Dictionary 입니다.
     - Returns: 추가 성공 시 URLRequest 를, 실패 시 `nil` 을 리턴합니다.
     */
    func addHeaders(_ headers: [String: String]?) -> URLRequest {
        var request = self

        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
