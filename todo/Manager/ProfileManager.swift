//
//  ProfileManager.swift
//  todo
//
//  Created by admin on 18.12.2023.
//

import Foundation
import UIKit

protocol ProfileManager {
    func getUser() async throws -> UserResponse
    func uploadUserPhoto(image: UIImage) async throws -> EmptyResponse
}

extension NetworkManager: ProfileManager {
    func getUser() async throws -> UserResponse {
        guard let accessToken = UserManager.shared.accessToken else {
            await ParentViewController.logOutAccount()
            throw NetworkError.notAuthorized
        }
        let response: UserResponse = try await request(
            path: PathURL.getUser.path,
            httpMethod: HttpMethod.get.method,
            accessToken: accessToken
        )
        return response
    }

    func uploadUserPhoto(image: UIImage) async throws -> EmptyResponse {
        guard let accessToken = UserManager.shared.accessToken else {
            await ParentViewController.logOutAccount()
            throw NetworkError.notAuthorized
        }

        guard let imageJpg = image.jpegData(compressionQuality: 0.9) else {
            throw NetworkError.wrongSizeImage
        }

        let response: EmptyResponse = try await request(
            path: PathURL.uploadUserPhoto.path,
            httpMethod: HttpMethod.post.method,
            httpBody: imageJpg,
            accessToken: accessToken
        )
        return response
    }
}
