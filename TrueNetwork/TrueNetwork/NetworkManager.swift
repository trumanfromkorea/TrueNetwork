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
    public func request(endpoint: API, completion: ((Result<Data, NetworkError>) -> Void)?) {
        // request 생성
        guard let urlRequest = generateRequest(endpoint: endpoint) else {
            completion?(.failure(.invalidRequest))
            return
        }

        // Request 전송
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            // error, statusCode 검사
            let statusCode = (response as? HTTPURLResponse)?.statusCode

            guard error == nil,
                  let statusCode = statusCode,
                  (200 ..< 300).contains(statusCode) else {
                completion?(.failure(.statusCode(code: statusCode ?? 0)))
                return
            }

            // response data 검사
            guard let resultData = data else {
                completion?(.failure(.invalidResponse))
                return
            }

            completion?(.success(resultData))
        }

        task.resume()
    }

    // Request 생성
    private func generateRequest(endpoint: API) -> URLRequest? {
        // url + paths
        let urlString = endpoint.baseUrl + endpoint.paths.reduce("", { partialResult, path in
            partialResult + "/\(path)"
        })

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
