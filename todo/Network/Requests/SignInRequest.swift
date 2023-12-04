//
//  SignInRequest.swift
//  todo
//
//  Created by admin on 02.12.2023.
//

import Foundation

struct SignInRequest: Encodable {
    let email: String
    let password: String
}
