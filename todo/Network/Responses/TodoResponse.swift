//
//  TodoResponse.swift
//  todo
//
//  Created by admin on 30.11.2023.
//

import Foundation

struct TodoResponse: Decodable {
    let id: String
    let category: String
    let title: String
    let description: String
    let date: Date
    let isCompleted: Bool
    let coordinate: Coordinate
}

struct Coordinate: Decodable, Encodable {
    let longitude: String
    let latitude: String
}
