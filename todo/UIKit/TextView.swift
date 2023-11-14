//
//  TextView.swift
//  todo
//
//  Created by admin on 12.11.2023.
//

import UIKit

final class TextView: UIView, UITextViewDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.Color.black
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    private let insets = UIEdgeInsets(top: 18, left: 16, bottom: 16, right: 16)
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.borderStyle = .none
        textView.backgroundColor = UIColor.Color.BackgroundAndSurfaces.surfaceSecondary
        textView.textColor = UIColor.Color.black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.tintColor = UIColor.Color.black
        textView.textContainerInset = insets
        textView.isScrollEnabled = false
        textView.delegate = self
        return textView
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
    
    override var intrinsicContentSize: CGSize {
        let height: CGFloat = titleLabel.intrinsicContentSize.height + 56
        if errorLabel.isHidden {
            return CGSize(width: UIView.noIntrinsicMetric, height: height)
        }
        let rect = errorLabel.textRect(forBounds: bounds, limitedToNumberOfLines: errorLabel.numberOfLines)
        return CGSize(width: UIView.noIntrinsicMetric, height: height + rect.height + 4)
    }
        
    private lazy var bottomConstraint = textView.bottomAnchor.constraint(equalTo: bottomAnchor)

    private func setup() {
        addSubview(titleLabel)
        addSubview(textView)
        addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomConstraint,
            textView.heightAnchor.constraint(equalToConstant: 56),
            
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            errorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func showError(error: String) {
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
    
    func setup(label: String?) {
        titleLabel.text = label
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                let height = min(max(estimatedSize.height, 56), 200)
                constraint.constant = height
                if height == 200 {
                    textView.isScrollEnabled = true
                }
            }
        }
    }
    
    @objc
    private func didBeginEditing() {
        hideError()
    }
}
