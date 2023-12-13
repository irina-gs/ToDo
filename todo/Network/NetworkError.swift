//
//  NetworkError.swift
//  todo
//
//  Created by admin on 13.12.2023.
//

import Foundation

enum NetworkError: LocalizedError {
    case wrongStatusCode, wrongURL, wrongResponse, notAuthorized

    var errorDescription: String? {
        switch self {
        case .wrongStatusCode:
            return L10n.NetworkError.wrongStatusCode
        case .wrongURL:
            return L10n.NetworkError.wrongUrl
        case .wrongResponse:
            return L10n.NetworkError.wrongResponse
        case .notAuthorized:
            return nil
        }
    }
}
