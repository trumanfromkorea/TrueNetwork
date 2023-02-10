//
//  NetworkProvider.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/10/18.
//

import Foundation

public final class NetworkProvider<T: Codable> {
    let timeoutInterval: CGFloat

    public init(timeoutInterval: CGFloat = 5) {
        self.timeoutInterval = timeoutInterval
    }

    // Request 전송
    public func request(
        endpoint: RequestConvertible,
        completion: ((Result<T, NetworkError>) -> Void)?
    ) {
        // request 생성
        guard let urlRequest = endpoint.request(timeoutInterval: timeoutInterval) else {
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

            // 타입 변환 시도
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion?(.success(result))
            } catch {
                // 실패 시 json 파일로 덤프
                self.writeExceptionData(data: data)
                completion?(.failure(.invalidType))
            }
        }

        task.resume()
    }

    private func writeExceptionData(data: Data) {
        guard let jsonString = String(data: data, encoding: .utf8),
              let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let pathWithFilename = documentDirectory.appendingPathComponent("exceptionData.json")

        do {
            try jsonString.write(to: pathWithFilename, atomically: true, encoding: .utf8)
            print("Data exception, wrote file at ..")
            print(documentDirectory)
        } catch {
            print(error)
        }
    }
}
