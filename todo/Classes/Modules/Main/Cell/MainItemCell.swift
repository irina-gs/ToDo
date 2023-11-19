//
//  MainItemCell.swift
//  todo
//
//  Created by admin on 14.11.2023.
//

import UIKit

final class MainItemCell: UICollectionViewCell {
    static let reuseID = String(describing: MainItemCell.self)
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var iconView: UIImageView!
    @IBOutlet private var deadlineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        updateColor()
    }
    
    override var isSelected: Bool {
        didSet {
            updateColor()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1
        }
    }
    
    private func setup() {
        backgroundColor = UIColor.Color.BackgroundAndSurfaces.mainItemCell
        layer.cornerRadius = 16
        titleLabel.textColor = UIColor.Color.black
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        deadlineLabel.textColor = UIColor.Color.black
        deadlineLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    private func updateDeadlineTextColor() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = L10n.Main.dateFormat
        let deadlineDate = dateFormatter.date(from: deadlineLabel.text ?? "") ?? .now

        deadlineLabel.textColor = deadlineDate > Date() ? UIColor.Color.black : UIColor.Color.exit
    }
        
    func setup(item: MainDataItem) {
        titleLabel.text = item.title
        deadlineLabel.text = item.deadline
        updateDeadlineTextColor()
    }
    
    private func updateColor() {
        iconView.image = isSelected ? UIImage.MainItemCell.iconTrue : UIImage.MainItemCell.iconFalse
    }
}
