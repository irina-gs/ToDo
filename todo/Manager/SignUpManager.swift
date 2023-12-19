//
//  SignUpManager.swift
//  todo
//
//  Created by admin on 18.12.2023.
//

import Foundation

protocol SignUpManager {
    func signUp(name: String, email: String, password: String) async throws -> AuthResponse
}

extension NetworkManager: SignUpManager {
    func signUp(name: String, email: String, password: String) async throws -> AuthResponse {
        let response: AuthResponse = try await request(
            path: PathURL.signUp.path,
            httpMethod: HttpMethod.post.method,
            httpBody: SignUpRequest(name: name, email: email, password: password)
        )
        UserManager.shared.set(accessToken: response.accessToken)
        return response
    }
}
