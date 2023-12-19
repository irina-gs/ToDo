//
//  Data+.swift
//  todo
//
//  Created by admin on 18.12.2023.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
