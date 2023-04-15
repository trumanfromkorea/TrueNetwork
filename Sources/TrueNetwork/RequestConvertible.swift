//
//  RequestConvertible.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/10/18.
//

import Foundation

/**
 서버 통신에 쓰이는 일반적인 요소들의 규격을 나타낸 프로토콜입니다.
 
 해당 프로토콜을 준수하는 경우 서버 통신에 사용할 수 있습니다. ``NetworkProvider`` 클래스의 `request` 메소드의 파라미터로 사용됩니다.
 */
public protocol RequestConvertible {
    var baseUrl: String { get }
    var method: HTTPMethod { get }
    var paths: [String] { get }
    var parameters: [String: Any]? { get }
    var body: [String: Any]? { get }
    var headers: [String: String]? { get }
    
    func request(timeoutInterval: CGFloat) -> URLRequest?
}

public extension RequestConvertible {
    /**
     서버 요청에 쓰이는 request 를 생성합니다.
     
     - Parameters:
        - timeoutInterval: 요청 기한입니다.
     */
    func request(timeoutInterval: CGFloat) -> URLRequest? {
        // paths, params
        let url = URL(string: baseUrl)?
            .addPaths(paths)?
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

