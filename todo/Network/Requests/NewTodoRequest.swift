//
//  NewTodoRequest.swift
//  todo
//
//  Created by admin on 02.12.2023.
//

import Foundation

struct NewTodoRequest: Encodable {
    let category: String = ""
    let title: String
    let description: String
    let date: Date
    let coordinate: Coordinate = .init(longitude: "0", latitude: "0")
}

struct Coordinate: Encodable {
    let longitude: String
    let latitude: String
}
