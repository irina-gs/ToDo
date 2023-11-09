//
//  TextInput.swift
//  todo
//
//  Created by admin on 02.11.2023.
//

import UIKit

final class TextInput: UIView {
    
    private lazy var textField: TextField = {
        let textField = TextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        return textField
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.textColor = UIColor.Color.error
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override var intrinsicContentSize: CGSize {
        let height: CGFloat = 56
        if errorLabel.isHidden {
            return CGSize(width: UIView.noIntrinsicMetric, height: height)
        }
        let rect = errorLabel.textRect(forBounds: bounds, limitedToNumberOfLines: errorLabel.numberOfLines)
        return CGSize(width: UIView.noIntrinsicMetric, height: height + rect.height + 4)
    }
    
    func setup(placeholder: String?, text: String?) {
        textField.placeholder = placeholder
        textField.text = text
    }
    
    func show(error: String) {
        errorLabel.text = error
        bottomConstraint.isActive = false
        errorLabel.isHidden = false
        invalidateIntrinsicContentSize()
    }
    
    func hideError() {
        errorLabel.isHidden = true
        bottomConstraint.isActive = true
        invalidateIntrinsicContentSize()
    }
    
    func enableSecurityMode() {
        textField.enableSecurityMode()
    }
    
    private lazy var bottomConstraint = textField.bottomAnchor.constraint(equalTo: bottomAnchor)
    
    private func setup() {
        addSubview(textField)
        addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomConstraint,
            
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
    
    var text: String? {
        textField.text
    }
    
    @objc
    private func didBeginEditing() {
        hideError()
    }
}
