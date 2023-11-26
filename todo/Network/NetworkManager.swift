//
//  NetworkManager.swift
//  todo
//
//  Created by admin on 23.11.2023.
//

import Foundation
import Combine

enum NetworkError: LocalizedError {
    case wrongStatusCode, wrongURL, wrongResponse
    
    var errorDescription: String? {
        switch self {
        case .wrongStatusCode:
            return "Упс. Что-то пошло не так"
        case .wrongURL:
            return "Упс. Что-то пошло не так"
        case .wrongResponse:
            return "Упс. Что-то пошло не так"
        }
    }
}

struct SignInRequuestBody: Encodable {
    let email: String
    let password: String
}

final class NetworkManager {
    static var shared = NetworkManager()
    
    private init() {}
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func signIn(email: String, password: String) async throws -> AuthResponse {
        guard let url = URL(string: "\(PlistFiles.cfApiBaseUrl)/api/auth/login") else {
            throw NetworkError.wrongURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(SignInRequuestBody(email: email, password: password))
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, resp) = try await URLSession.shared.data(for: request)
        if let httpResponce = resp as? HTTPURLResponse {
            switch httpResponce.statusCode {
            case 200 ..< 400:
                log.debug("\(String(decoding: data, as: UTF8.self))")
                return try decoder.decode(DataResponse<AuthResponse>.self, from: data).data
            default:
                let response = String(data: data, encoding: .utf8) ?? ""
                log.debug("\(response)")
                throw NetworkError.wrongStatusCode
            }
        } else {
            throw NetworkError.wrongResponse
        }
    }
}
