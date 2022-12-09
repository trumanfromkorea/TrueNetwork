//
//  PostInfo.swift
//  Example
//
//  Created by 장재훈 on 2022/12/07.
//

import Foundation

struct PostInfo: Codable, CustomStringConvertible {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    

    var description: String {
        return """
        
        PostInfo: {
            id: \(id)
            title: \(title)
            body: \(body)
            userId: \(userId)
        }
        
        """
    }

    var dict: [String: Any]? {
        guard let object = try? JSONEncoder().encode(self),
              let dict = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else {
            return nil
        }

        return dict
    }
}
