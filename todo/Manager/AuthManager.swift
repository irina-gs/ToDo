//
//  AuthManager.swift
//  todo
//
//  Created by admin on 14.12.2023.
//

import Foundation

protocol AuthManager {
    func signIn(email: String, password: String) async throws -> AuthResponse
}

extension NetworkManager: AuthManager {
    func signIn(email: String, password: String) async throws -> AuthResponse {
        let response: AuthResponse = try await request(
            path: PathURL.signIn.path,
            httpMethod: HttpMethod.post.method,
            httpBody: SignInRequest(email: email, password: password)
        )
        UserManager.shared.set(accessToken: response.accessToken)
        return response
    }
}
