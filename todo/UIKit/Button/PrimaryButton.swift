//
//  PrimaryButton.swift
//  todo
//
//  Created by admin on 09.11.2023.
//

import UIKit

final class PrimaryButton: MainButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    enum Mode {
        case large
        case small
    }

    private var mode: Mode = .large

    func setMode(mode: Mode) {
        self.mode = mode
        setup()
    }

    private func setup() {
        switch mode {
        case .large:
            style = Style(
                cornerRadius: 8,
                insets: 32,
                bgColor: .Color.primary,
                highlightedBgColor: .Color.primary.withAlphaComponent(0.5),
                titleColor: .Color.white,
                highlightedTitleColor: .Color.white
            )
            loader.image = UIImage.Common.loaderMedium
        case .small:
            style = Style(
                cornerRadius: 8,
                insets: 44,
                height: 34,
                bgColor: .Color.primary,
                highlightedBgColor: .Color.primary.withAlphaComponent(0.5),
                titleColor: .Color.white,
                highlightedTitleColor: .Color.white
            )
            loader.image = UIImage.Common.loaderSmall
        }
    }

    private lazy var loader: LoadingIndicatorImageView = {
        let loader = LoadingIndicatorImageView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.isHidden = true

        addSubview(loader)

        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        return loader
    }()

    func showLoadingState() {
        loader.isHidden = false
        titleLabel?.isHidden = true
        imageView?.isHidden = true
        isUserInteractionEnabled = false
    }

    func hideLoadingState() {
        loader.isHidden = true
        titleLabel?.isHidden = false
        imageView?.isHidden = false
        isUserInteractionEnabled = true
    }
}
