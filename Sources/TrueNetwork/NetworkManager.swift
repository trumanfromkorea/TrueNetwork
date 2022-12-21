//
//  NetworkManager.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/10/18.
//

import Foundation

@available(iOS 16.0, *)
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

            guard let result: T = try? JSONDecoder().decode(T.self, from: data) else {
                completion?(.failure(.invalidType))
                return
            }

            completion?(.success(result))
        }

        task.resume()
    }

    // Request 생성
    private func generateRequest(endpoint: RequestConvertible) -> URLRequest? {
        // paths, params
        let url = URL(string: endpoint.baseUrl)?
            .addPaths(endpoint.paths)
            .addParameters(endpoint.parameters)

        guard let url else {
            return nil
        }

        // request, method
        var request = URLRequest(url: url)
            .addBody(endpoint.body)
            .addHeaders(endpoint.headers)

        request.httpMethod = endpoint.method.label

        return request
    }
}
