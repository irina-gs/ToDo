//
//  ValidationManager.swift
//  todo
//
//  Created by admin on 09.11.2023.
//

import Foundation

enum ValidationManager {
    static func isValid(commonText: String?) -> Bool {
        (commonText ?? "").count != 0
    }
    
    static func isValid(email: String?) -> Bool {
        let emailParameters = ".+@.+\\..+"
        return NSPredicate(format: "SELF MATCHES %@", emailParameters).evaluate(with: email)
    }
    
    static func isValid(commonText: String?, symbolsCount: Int) -> Bool {
//        if let commonText {
//            return commonText.count <= symbolsCount
//        }
//        return false
//
//        (commonText?.count ?? 0) <= symbolsCount

        (commonText ?? "").count <= symbolsCount
    }
}
