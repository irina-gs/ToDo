//
//  TextField.swift
//  todo
//
//  Created by admin on 02.11.2023.
//

import UIKit

final class TextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func enableSecurityMode() {
        textContentType = .password
        isSecureTextEntry = true
        rightView = showPasswordButton
        rightViewMode = .always
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds).inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds).inset(by: insets)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        super.rightViewRect(forBounds: bounds).inset(by: UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 16))
    }

    private let insets = UIEdgeInsets(top: 18, left: 16, bottom: 16, right: 16)

    private lazy var showPasswordButton: UIButton = {
        let button = UIButton(type: .custom, primaryAction: UIAction(handler: { [weak self] _ in
            self?.toggleSecureMode()
        }))
        button.frame = CGRect(origin: .zero, size: CGSize(width: 24, height: 24))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.setImage(UIImage.TextInput.eyeOpen, for: .normal)
        button.setImage(UIImage.TextInput.eyeClose, for: .selected)
        return button
    }()

    private func setup() {
        borderStyle = .none
        backgroundColor = UIColor.Color.BackgroundAndSurfaces.surfaceSecondary
        textColor = UIColor.Color.black
        font = UIFont.systemFont(ofSize: 16)
        layer.cornerRadius = 8
        tintColor = UIColor.Color.black

        attributedPlaceholder = NSMutableAttributedString(
            string: " ",
            attributes: [.foregroundColor: UIColor.Color.Text.textSecondary, .font: UIFont.systemFont(ofSize: 16)]
        )
    }

    private func toggleSecureMode() {
        showPasswordButton.isSelected.toggle()
        isSecureTextEntry = !showPasswordButton.isSelected
    }
}
