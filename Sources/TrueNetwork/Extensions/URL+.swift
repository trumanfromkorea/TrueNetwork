//
//  URL+.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/12/08.
//

import Foundation

extension URL {
    func addPaths(_ paths: [String]) -> URL? {
        let urlString = absoluteString + "/" + paths.joined(separator: "/")

        return .init(string: urlString)
    }

    func addParameters(_ parameters: [String: Any]?) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters?.compactMap { URLQueryItem(name: $0, value: "\($1)") }

        return components?.url
    }
}
