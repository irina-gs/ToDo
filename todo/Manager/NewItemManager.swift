//
//  NewItemManager.swift
//  todo
//
//  Created by admin on 18.12.2023.
//

import Foundation

protocol NewItemManager {
    func newTodo(title: String, description: String, date: Date) async throws -> MainDataItem
    func deleteTodo(id: String) async throws -> EmptyResponse
}

extension NetworkManager: NewItemManager {
    func newTodo(title: String, description: String, date: Date) async throws -> MainDataItem {
        guard let accessToken = UserManager.shared.accessToken else {
            await ParentViewController.logOutAccount()
            throw NetworkError.notAuthorized
        }
        let response: MainDataItem = try await request(
            path: PathURL.newTodo.path,
            httpMethod: HttpMethod.post.method,
            httpBody: NewTodoRequest(title: title, description: description, date: date),
            accessToken: accessToken
        )
        return response
    }

    func deleteTodo(id: String) async throws -> EmptyResponse {
        guard let accessToken = UserManager.shared.accessToken else {
            await ParentViewController.logOutAccount()
            throw NetworkError.notAuthorized
        }
        let response: EmptyResponse = try await request(
            path: PathURL.deleteTodo(id: id).path,
            httpMethod: HttpMethod.delete.method,
            accessToken: accessToken
        )
        return response
    }
}
