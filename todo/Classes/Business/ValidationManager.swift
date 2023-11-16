//
//  ValidationManager.swift
//  todo
//
//  Created by admin on 09.11.2023.
//

import Foundation

enum ValidationManager {
    static func isValid(email: String?) -> Bool {
        let emailParameters = ".+@.+\\..+"
        return NSPredicate(format: "SELF MATCHES %@", emailParameters).evaluate(with: email)
    }
    
    static func isValid(commonText: String?, symbolsCount: Int) -> Bool {
        (commonText ?? "").count <= symbolsCount
    }
}
