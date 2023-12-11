//
//  UserResponse.swift
//  todo
//
//  Created by admin on 09.12.2023.
//

import Foundation

struct UserResponse: Decodable {
    let name: String
    let email: String
    let imageId: String
}
