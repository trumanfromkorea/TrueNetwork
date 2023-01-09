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
    
    func request(timeoutInterval: CGFloat) -> URLRequest?
}

@available(iOS 16.0, *)
public extension RequestConvertible {
    func request(timeoutInterval: CGFloat) -> URLRequest? {
        // paths, params
        let url = URL(string: baseUrl)?
            .addPaths(paths)
            .addParameters(parameters)

        guard let url else {
            return nil
        }

        // request, method
        var request = URLRequest(url: url)
            .addBody(body)
            .addHeaders(headers)

        request.httpMethod = method.label
        request.timeoutInterval = timeoutInterval

        return request
    }
}

