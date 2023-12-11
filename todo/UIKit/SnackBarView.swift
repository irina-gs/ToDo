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

    private lazy var massageLabel: UILabel = {
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

        addSubview(massageLabel)

        NSLayoutConstraint.activate([
            massageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            massageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            massageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            massageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }

    func setupMassage(massage: String?) {
        massageLabel.text = massage
    }

    func show(view: UIView) {
        let height: CGFloat = 88

        frame = CGRect(x: 0, y: -height, width: view.frame.size.width, height: height)

        view.addSubview(self)

        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: height)
        }, completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.frame = CGRect(x: 0, y: -height, width: view.frame.size.width, height: height)
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
