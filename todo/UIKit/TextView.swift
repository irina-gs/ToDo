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
    
    func setup(label: String?) {
        titleLabel.text = label
    }
    
    override var intrinsicContentSize: CGSize {
        let height: CGFloat = titleLabel.intrinsicContentSize.height + heightTVConstraint.constant + 8
        if errorLabel.isHidden {
            return CGSize(width: UIView.noIntrinsicMetric, height: height)
        }
        let rect = errorLabel.textRect(forBounds: bounds, limitedToNumberOfLines: errorLabel.numberOfLines)
        return CGSize(width: UIView.noIntrinsicMetric, height: height + rect.height + 4)
    }
        
    private lazy var bottomTVConstraint = textView.bottomAnchor.constraint(equalTo: bottomAnchor)
    private lazy var heightTVConstraint = textView.heightAnchor.constraint(equalToConstant: 56)
    private lazy var topErrorConstraint = errorLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4)

    private func setup() {
        addSubview(titleLabel)
        addSubview(textView)
        addSubview(errorLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            heightTVConstraint,
            bottomTVConstraint,

            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let height = min(max(estimatedSize.height, 56), 200)
        heightTVConstraint.constant = height
        textView.isScrollEnabled = (height == 200)
        invalidateIntrinsicContentSize()
    }
    
    func show(error: String) {
        errorLabel.text = error
        bottomTVConstraint.isActive = false
        topErrorConstraint.isActive = true
        errorLabel.isHidden = false
        invalidateIntrinsicContentSize()
    }
    
    func hideError() {
        errorLabel.isHidden = true
        bottomTVConstraint.isActive = true
        topErrorConstraint.isActive = false
        invalidateIntrinsicContentSize()
    }
    
    @objc
    private func didBeginEditing() {
        hideError()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        didBeginEditing()
    }
}
