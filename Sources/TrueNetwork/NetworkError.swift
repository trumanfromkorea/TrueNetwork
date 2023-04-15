//
//  NetworkError.swift
//  TrueNetwork
//
//  Created by 장재훈 on 2022/10/18.
//

import Foundation

/**
 요청 중 발생하는 에러를 나타낼 수 있는 case 들입니다.
 */
public enum NetworkError: LocalizedError {
    /// 잘못된 요청, 400 번대 에러
    case invalidRequest
    /// 유효하지 않은 응답
    case invalidResponse
    /// 서버로부터 받아온 데이터가 유효하지 않은 경우
    case invalidData
    /// 서버로부터 받아온 데이터와 매핑 타입이 일치하지 않는 경우
    case invalidType
    /// 서버 내부 오류, 500 번대 에러
    case serverError
    /// 네트워크 통신에 실패한 경우
    case networkFailed

    /// 모든 에러 case 에 대한 설명입니다.
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

    /**
     네트워크 응답 코드를 이용해 어떤 종류의 에러인지 판단합니다.
     
     - Parameters:
        - statusCode: 네트워크 응답 코드입니다.
     - Returns: 응답 코드에 대응하는 에러를 리턴합니다.
     */
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
