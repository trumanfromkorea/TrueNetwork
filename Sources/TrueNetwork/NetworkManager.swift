//
//  NetworkProvider.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/10/18.
//

import Foundation

/**
 네트워크 통신 기능을 제공하는 객체입니다. 응답을 처리하기 위해 `Codable` 프로토콜을 준수하는 제네릭 타입을 이용합니다.
 */
public final class NetworkProvider<T: Codable> {
    /// 서버 요청 기한입니다.
    let timeoutInterval: CGFloat

    /// 생성 시 서버 요청 기한을 입력하지 않을 시 기본값은 5초입니다.
    public init(timeoutInterval: CGFloat = 5) {
        self.timeoutInterval = timeoutInterval
    }

    /**
     네트워크 요청을 전송합니다.
     
     - Parameters:
        - endpoint: 네트워크 요청에 사용되는 요소들입니다.
        - completion: 응답이 도착한 후 이를 처리할 수 있는 closure 구문입니다.
     */
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

    /**
     서버로부터 도착한 데이터에서 예외 발생 시 해당 데이터를 json 파일로 기기 내에 저장합니다.
     
     - Parameters:
        - data: 예외가 발생한 데이터입니다.
     */
    private func writeExceptionData(data: Data) {
        // Documents 폴더에 저장
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
