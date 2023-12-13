//
//  AuthError.swift
//  todo
//
//  Created by admin on 13.12.2023.
//

import UIKit

enum AuthError {
    static func logOutAccount() {
        UserManager.shared.reset()
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        DispatchQueue.main.async {
            UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.last?.rootViewController = storyboard.instantiateInitialViewController()
        }
    }
}
