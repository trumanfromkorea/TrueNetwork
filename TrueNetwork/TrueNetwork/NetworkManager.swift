//
//  NetworkManager.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/10/18.
//

import Foundation

public final class NetworkManager {
    public static let shared = NetworkManager()
    private init() {}

    // Request 전송
    public func request<T: Codable>(
        endpoint: RequestConvertible,
        dataType: T.Type,
        completion: ((Result<T, NetworkError>) -> Void)?
    ) {
        // request 생성
        guard let urlRequest = generateRequest(endpoint: endpoint) else {
            completion?(.failure(.invalidRequest))
            return
        }

        // Request 전송
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            // error, statusCode 검사
            guard let httpResponse = (response as? HTTPURLResponse) else {
                completion?(.failure(.invalidResponse))
                return
            }

            let statusCode = httpResponse.statusCode

            guard error == nil,
                  (200 ..< 300).contains(statusCode) else {
                completion?(.failure(NetworkError.judgeStatus(by: statusCode)))
                return
            }

            // response data 검사
            guard let data else {
                completion?(.failure(.invalidData))
                return
            }

            print(String(data: data, encoding: .utf8))

            guard let result: T = try? JSONDecoder().decode(T.self, from: data) else {
                completion?(.failure(.invalidType))
                return
            }

            completion?(.success(result))
        }

        task.resume()
    }

    // Request 생성
//    private func generateRequest(endpoint: RequestConvertible) -> URLRequest? {
//        guard var urlComponents = URLComponents(string: endpoint.baseUrl) else {
//            return nil
//        }
//
//        urlComponents.addPaths(endpoint.paths)
//        urlComponents.addParameters(endpoint.parameters)
//
//        print(urlComponents.url)
//
//        guard let url = urlComponents.url else {
//            return nil
//        }
//
//        // request, method
//        var request = URLRequest(url: url)
//        request.httpMethod = endpoint.method.label
//        request.addBody(endpoint.body)
//        request.addHeaders(endpoint.headers)
//
//        return request
//    }

    // Request 생성
    private func generateRequest(endpoint: RequestConvertible) -> URLRequest? {
        // url + paths
        let urlString = endpoint.baseUrl + "/" + endpoint.paths.joined(separator: "/")

        // parameters
        guard var urlComponents = URLComponents(string: urlString) else {
            return nil
        }

        endpoint.parameters?.forEach({ key, value in
            let query = URLQueryItem(name: key, value: "\(value)")

            if urlComponents.queryItems == nil { urlComponents.queryItems = [] }
            urlComponents.queryItems?.append(query)
        })

        guard let url = urlComponents.url else {
            return nil
        }

        // request, method
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.label

        // body
        if let body = endpoint.body,
           let bodyData = try? JSONSerialization.data(withJSONObject: body) {
            request.httpBody = bodyData
        }

        // headers
        endpoint.headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
