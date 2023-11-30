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
            return L10n.NetworkError.wrongStatusCode
        case .wrongURL:
            return L10n.NetworkError.wrongURL
        case .wrongResponse:
            return L10n.NetworkError.wrongResponse
        }
    }
}

struct SignInRequestBody: Encodable {
    let email: String
    let password: String
}

struct SignUpRequestBody: Encodable {
    let name: String
    let email: String
    let password: String
}

struct NewTodoRequestBody: Encodable {
    let category: String = ""
    let title: String
    let description: String
    let date: Date
    let coordinate: Coordinate = Coordinate(longitude: "0", latitude: "0")
}

struct EmptyBody: Encodable {}

final class NetworkManager {
    static var shared = NetworkManager()
    
    private init() {}
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        return encoder
    }()
    
    private func request<Request: Encodable, Response: Decodable>(
        urlPath: String,
        httpMethod: String,
        httpBody: Request,
        accessToken: String? = nil,
        flagBody: Bool = true
    ) async throws -> Response {
        guard let url = URL(string: "\(PlistFiles.cfApiBaseUrl)\(urlPath)") else {
            throw NetworkError.wrongURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        if flagBody {
            request.httpBody = try encoder.encode(httpBody)
        }
        
        if let accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, resp) = try await URLSession.shared.data(for: request)
        if let httpResponse = resp as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200 ..< 400:
                if data.isEmpty, let emptyData = "{}".data(using: .utf8) {
                    return try decoder.decode(Response.self, from: emptyData)
                }
                log.debug("\(String(decoding: data, as: UTF8.self))")
                return try decoder.decode(DataResponse<Response>.self, from: data).data
            default:
                let response = String(data: data, encoding: .utf8) ?? ""
                log.debug("\(response)")
                throw NetworkError.wrongStatusCode
            }
        } else {
            throw NetworkError.wrongResponse
        }
    }
    
    func signIn(email: String, password: String) async throws -> AuthResponse {
        let response: AuthResponse = try await request(
            urlPath: "/api/auth/login",
            httpMethod: "POST",
            httpBody: SignInRequestBody(email: email, password: password)
        )
        UserDefaults.standard.set(response.accessToken, forKey: "accessToken")
        return response
    }
    
    func signUp(name: String, email: String, password: String) async throws -> AuthResponse {
        let response: AuthResponse = try await request(
            urlPath: "/api/auth/registration",
            httpMethod: "POST",
            httpBody: SignUpRequestBody(name: name, email: email, password: password)
        )
        UserDefaults.standard.set(response.accessToken, forKey: "accessToken")
        return response
    }
    
    func newTodo(title: String, description: String, date: Date) async throws -> TodoResponse {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            throw NetworkError.wrongResponse
        }
        let response: TodoResponse = try await request(
            urlPath: "/api/todos",
            httpMethod: "POST",
            httpBody: NewTodoRequestBody(title: title, description: description, date: date),
            accessToken: accessToken
        )
        return response
    }
    
    func getTodos() async throws -> [TodoResponse] {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            throw NetworkError.wrongResponse
        }
        let response: [TodoResponse] = try await request(
            urlPath: "/api/todos",
            httpMethod: "Get",
            httpBody: EmptyBody(),
            accessToken: accessToken,
            flagBody: false
        )
        return response
    }
    
    func changeMark(id: String) async throws -> EmptyResponse {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            throw NetworkError.wrongResponse
        }
        let response: EmptyResponse = try await request(
            urlPath: "/api/todos/mark/\(id)",
            httpMethod: "PUT",
            httpBody: EmptyBody(),
            accessToken: accessToken,
            flagBody: false
        )
        return response
    }
}
