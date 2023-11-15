//
//  MainItemCell.swift
//  todo
//
//  Created by admin on 14.11.2023.
//

import UIKit

final class MainItemCell: UICollectionViewCell {
    static let reuseID = String(describing: MainItemCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateColor()
    }
    
    override var isSelected: Bool {
        didSet {
            updateColor()
        }
    }
    
    func setup(item: MainDataItem) {
        titleLabel.text = item.title
    }
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var iconView: UIImageView!
    
    private func updateColor() {
        iconView.backgroundColor = isSelected ? UIColor.Color.primary : UIColor.Color.BackgroundAndSurfaces.surfaceSecondary
    }
}
