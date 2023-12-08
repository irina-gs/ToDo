//
//  DateFormatter.swift
//  todo
//
//  Created by admin on 26.11.2023.
//

import UIKit

extension DateFormatter {
    static let `default` = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = L10n.Main.dateFormat
        return formatter
    }()
    
    static let dMMM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }()
}
