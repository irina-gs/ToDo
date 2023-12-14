//
//  MainDataItem.swift
//  todo
//
//  Created by admin on 13.12.2023.
//

import Foundation

struct MainDataItem: Decodable {
    let id: String
    let title: String
    let description: String
    let date: Date
    var isCompleted: Bool
}
