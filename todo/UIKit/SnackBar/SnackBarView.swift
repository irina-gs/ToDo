//
//  SnackBarView.swift
//  todo
//
//  Created by admin on 10.12.2023.
//

import UIKit

final class SnackBarView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.Color.white
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private func setup() {
        backgroundColor = UIColor.Color.gray1
        addSubview(messageLabel)
    }

    func setupMessage(message: String?) {
        messageLabel.text = message
    }

    func show(view: UIView) {
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 50),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])

        let height: CGFloat = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 50) + messageLabel.sizeThatFits(CGSize(width: frame.width, height: .infinity)).height + 20

        let startFrame = CGRect(x: 0, y: -height, width: view.frame.size.width, height: height)
        frame = startFrame

        view.window?.addSubview(self)

        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: height)
        }, completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.frame = startFrame
                    }, completion: { finished in
                        if finished {
                            self.removeFromSuperview()
                        }
                    })
                }
            }
        })
    }
}
