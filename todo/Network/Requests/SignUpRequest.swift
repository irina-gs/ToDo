//
//  SignUpRequest.swift
//  todo
//
//  Created by admin on 02.12.2023.
//

import Foundation

struct SignUpRequest: Encodable {
    let name: String
    let email: String
    let password: String
}
