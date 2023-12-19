//
//  NetworkManager.swift
//  todo
//
//  Created by admin on 23.11.2023.
//

import Combine
import Foundation

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
    case signIn, signUp, newTodo, getTodos, changeMark(id: String), deleteTodo(id: String), getUser, uploadUserPhoto, getUserPhoto(fileId: String)

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
        case .getUser:
            return "/api/user"
        case .uploadUserPhoto:
            return "/api/user/photo"
        case let .getUserPhoto(fileId):
            return "/api/user/photo/\(fileId)"
        }
    }
}

final class NetworkManager {
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(decoder: JSONDecoder, encoder: JSONEncoder) {
        self.decoder = decoder
        self.encoder = encoder
    }

    func request<Response: Decodable>(path: String, httpMethod: String, accessToken: String? = nil) async throws -> Response {
        try await request(path: path, httpMethod: httpMethod, httpBody: EmptyRequest?.none, accessToken: accessToken)
    }

    func request<Request: Encodable, Response: Decodable>(path: String, httpMethod: String, httpBody: Request?, accessToken: String? = nil) async throws -> Response {
        guard let url = URL(string: "\(PlistFiles.apiBaseUrl)\(path)") else {
            throw NetworkError.wrongURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod

        if let imageJpg = httpBody as? Data {
            let boundary = UUID().uuidString

            request.httpBody = multipartFormDataBody(imageJpg: imageJpg, boundary: boundary)
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        } else {
            if let httpBody {
                request.httpBody = try encoder.encode(httpBody)
            }

            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }

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
            case 401:
                await ParentViewController.logOutAccount()
                throw NetworkError.notAuthorized
            default:
                throw NetworkError.wrongStatusCode
            }
        } else {
            throw NetworkError.wrongResponse
        }
    }

    private func multipartFormDataBody(imageJpg: Data, boundary: String) -> Data {
        var body = Data()
        body.append("\r\n--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"uploadedFile\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageJpg)
        body.append("\r\n--\(boundary)--\r\n")
        return body
    }
}
