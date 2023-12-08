//
//  NetworkManager.swift
//  todo
//
//  Created by admin on 23.11.2023.
//

import Combine
import Foundation

enum NetworkError: LocalizedError {
    case wrongStatusCode, wrongURL, wrongResponse

    var errorDescription: String? {
        switch self {
        case .wrongStatusCode:
            return L10n.NetworkError.wrongStatusCode
        case .wrongURL:
            return L10n.NetworkError.wrongUrl
        case .wrongResponse:
            return L10n.NetworkError.wrongResponse
        }
    }
}

enum HttpMethod {
    case get, post, put, delete

    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}

enum PathURL {
    case signIn, signUp, newTodo, getTodos, changeMark(id: String), deleteTodo(id: String)

    var path: String {
        switch self {
        case .signIn:
            return "/api/auth/login"
        case .signUp:
            return "/api/auth/registration"
        case .newTodo:
            return "/api/todos"
        case .getTodos:
            return "/api/todos"
        case let .changeMark(id):
            return "/api/todos/mark/\(id)"
        case let .deleteTodo(id):
            return "/api/todos/\(id)"
        }
    }
}

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

    private func request<Response: Decodable>(path: String, httpMethod: String, accessToken: String? = nil) async throws -> Response {
        try await request(path: path, httpMethod: httpMethod, httpBody: EmptyRequest?.none, accessToken: accessToken)
    }

    private func request<Request: Encodable, Response: Decodable>(path: String, httpMethod: String, httpBody: Request?, accessToken: String? = nil) async throws -> Response {
        guard let url = URL(string: "\(PlistFiles.apiBaseUrl)\(path)") else {
            throw NetworkError.wrongURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod

        if let httpBody {
            request.httpBody = try encoder.encode(httpBody)
        }

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        let (data, resp) = try await URLSession.shared.data(for: request)
        if let httpResponse = resp as? HTTPURLResponse {
            let response = String(data: data, encoding: .utf8) ?? ""
            log.debug("\(response)")

            switch httpResponse.statusCode {
            case 200 ..< 400:
                if data.isEmpty, let emptyData = "{}".data(using: .utf8) {
                    return try decoder.decode(Response.self, from: emptyData)
                }
                return try decoder.decode(DataResponse<Response>.self, from: data).data
            default:
                throw NetworkError.wrongStatusCode
            }
        } else {
            throw NetworkError.wrongResponse
        }
    }

    func signIn(email: String, password: String) async throws -> AuthResponse {
        let response: AuthResponse = try await request(
            path: PathURL.signIn.path,
            httpMethod: HttpMethod.post.method,
            httpBody: SignInRequest(email: email, password: password)
        )
        UserManager.shared.set(accessToken: response.accessToken)
        return response
    }

    func signUp(name: String, email: String, password: String) async throws -> AuthResponse {
        let response: AuthResponse = try await request(
            path: PathURL.signUp.path,
            httpMethod: HttpMethod.post.method,
            httpBody: SignUpRequest(name: name, email: email, password: password)
        )
        UserManager.shared.set(accessToken: response.accessToken)
        return response
    }

    func newTodo(title: String, description: String, date: Date) async throws -> MainDataItem {
        guard let accessToken = UserManager.shared.accessToken else {
            throw NetworkError.wrongStatusCode
        }
        let response: MainDataItem = try await request(
            path: PathURL.newTodo.path,
            httpMethod: HttpMethod.post.method,
            httpBody: NewTodoRequest(title: title, description: description, date: date),
            accessToken: accessToken
        )
        return response
    }

    func getTodos() async throws -> [MainDataItem] {
        guard let accessToken = UserManager.shared.accessToken else {
            throw NetworkError.wrongStatusCode
        }
        let response: [MainDataItem] = try await request(
            path: PathURL.getTodos.path,
            httpMethod: HttpMethod.get.method,
            accessToken: accessToken
        )
        return response
    }

    func changeMark(id: String) async throws -> EmptyResponse {
        guard let accessToken = UserManager.shared.accessToken else {
            throw NetworkError.wrongStatusCode
        }
        let response: EmptyResponse = try await request(
            path: PathURL.changeMark(id: id).path,
            httpMethod: HttpMethod.put.method,
            accessToken: accessToken
        )
        return response
    }

    func deleteTodo(id: String) async throws -> EmptyResponse {
        guard let accessToken = UserManager.shared.accessToken else {
            throw NetworkError.wrongStatusCode
        }
        let response: EmptyResponse = try await request(
            path: PathURL.deleteTodo(id: id).path,
            httpMethod: HttpMethod.delete.method,
            accessToken: accessToken
        )
        return response
    }
}
