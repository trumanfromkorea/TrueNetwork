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
            guard let resultData = data else {
                completion?(.failure(.invalidData))
                return
            }

            completion?(.success(resultData))
        }

        task.resume()
    }

    // Request 생성
    private func generateRequest(endpoint: API) -> URLRequest? {
        guard var urlComponents = URLComponents(string: endpoint.baseUrl) else {
            return nil
        }

        urlComponents.addPaths(endpoint.paths)
        urlComponents.addParameters(endpoint.parameters)

        guard let url = urlComponents.url else {
            return nil
        }

        // request, method
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.label
        request.addBody(endpoint.body)
        request.addHeaders(endpoint.headers)

        return request
    }
}
