//
//  URL+.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/12/08.
//

import Foundation

extension URL {
    /**
     URL 에 path 들을 추가합니다.

     - Parameters:
        - paths: Path 들의 이름을 담은 String Array 입니다.
     - Returns: 추가 성공 시 URL 을, 실패 시 `nil` 을 리턴합니다.
     */
    func addPaths(_ paths: [String]) -> URL? {
        let urlString = absoluteString + "/" + paths.joined(separator: "/")

        return .init(string: urlString)
    }

    /**
     URL 에 파라미터들을 추가합니다.

     - Parameters:
        - paths: 파라미터들을 담은 Dictionary 입니다.
     - Returns: 추가 성공 시 URL 을, 실패 시 `nil` 을 리턴합니다.
     */
    func addParameters(_ parameters: [String: Any]?) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters?.compactMap { URLQueryItem(name: $0, value: "\($1)") }

        return components?.url
    }
}
