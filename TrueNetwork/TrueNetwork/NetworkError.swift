//
//  NetworkError.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/10/18.
//

import Foundation

// 네트워크 에러
public enum NetworkError: LocalizedError {
    case invalidRequest
    case invalidResponse
    case invalidData

    case statusCode(code: Int)

    public var errorDescription: String {
        switch self {
        case .invalidRequest:
            return "잘못된 요청입니다."
        case .invalidResponse:
            return "유효하지 않은 데이터 응답입니다."
        case .invalidData:
            return "유효하지 않은 데이터입니다."
        case let .statusCode(code):
            return "Status Code: \(code)"
        }
    }
}
