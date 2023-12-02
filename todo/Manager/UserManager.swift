//
//  UserManager.swift
//  todo
//
//  Created by admin on 02.12.2023.
//

import Foundation

final class UserManager {
    static let shared = UserManager()
    
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    private let userDefaults: UserDefaults
    private let accessTokenKey = "accessTokenKey"
    
    private(set) var accessToken: String? {
        get {
            userDefaults.string(forKey: accessTokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: accessTokenKey)
        }
    }
    
    func set(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func reset() {
        accessToken = nil
    }
}
