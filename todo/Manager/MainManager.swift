//
//  MainManager.swift
//  todo
//
//  Created by admin on 18.12.2023.
//

import Foundation

protocol MainManager {
    func getTodos() async throws -> [MainDataItem]
    func changeMark(id: String) async throws -> EmptyResponse
}

extension NetworkManager: MainManager {
    func getTodos() async throws -> [MainDataItem] {
        guard let accessToken = UserManager.shared.accessToken else {
            await ParentViewController.logOutAccount()
            throw NetworkError.notAuthorized
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
            await ParentViewController.logOutAccount()
            throw NetworkError.notAuthorized
        }
        let response: EmptyResponse = try await request(
            path: PathURL.changeMark(id: id).path,
            httpMethod: HttpMethod.put.method,
            accessToken: accessToken
        )
        return response
    }
}
