//
//  URL+.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/12/08.
//

import Foundation

extension URL {
    func addPaths(_ paths: [String]) -> URL? {
        return paths.reduce(self) { $0.appending(path: $1) }
    }

    func addParameters(_ parameters: [String: Any]?) -> URL {
        var url = self

        let queryItems = parameters?.compactMap { URLQueryItem(name: $0, value: "\($1)") }

        if let queryItems {
            url.append(queryItems: queryItems)
        }

        return url
    }
}
