//
//  Array+.swift
//  Example
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

extension Array {
    var description: String {
        let content = self.reduce("") { partialResult, element in
            return partialResult + "\(element)"
        }
        
        return "[\n\(content)]"
    }
}
