//
//  TextButton.swift
//  todo
//
//  Created by admin on 11.11.2023.
//

import UIKit

final class TextButton: MainButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    enum Mode {
        case normal
        case destructive
    }
    
    private var mode: Mode = .normal
    
    func setMode(mode: Mode) {
        self.mode = mode
        setup()
    }
    
    private func setup() {
        switch mode {
        case .normal:
            style = Style(
                font: .systemFont(ofSize: 16, weight: .bold),
                insets: 32,
                height: 54,
                titleColor: .Color.black,
                highlightedTitleColor: .Color.black.withAlphaComponent(0.5)
            )
        case .destructive:
            style = Style(
                font: .systemFont(ofSize: 16, weight: .bold),
                insets: 32,
                height: 54,
                titleColor: .Color.exit,
                highlightedTitleColor: .Color.exit.withAlphaComponent(0.5)
            )
        }
    }
}
