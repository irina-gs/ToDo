//
//  DataResponse.swift
//  todo
//
//  Created by admin on 23.11.2023.
//

import Foundation

struct DataResponse<T: Decodable>: Decodable {
    let data: T
}
