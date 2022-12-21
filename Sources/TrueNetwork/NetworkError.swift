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
    case invalidType
    case serverError
    case networkFailed

    public var errorDescription: String {
        switch self {
        case .invalidRequest:
            return "잘못된 요청입니다."
        case .invalidResponse:
            return "유효하지 않은 데이터 응답입니다."
        case .invalidData:
            return "유효하지 않은 데이터입니다."
        case.invalidType:
            return "응답 데이터와 객체 정보가 일치하지 않습니다."
        case .serverError:
            return "서버 내부 에러입니다."
        case .networkFailed:
            return "네트워크 통신에 실패했습니다."
        }
    }

    static func judgeStatus(by statusCode: Int) -> NetworkError {
        if (400 ..< 500).contains(statusCode) {
            return .invalidRequest
        } else if (500 ..< 600).contains(statusCode) {
            return .serverError
        } else {
            return .networkFailed
        }
    }
}
