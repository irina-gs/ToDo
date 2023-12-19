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
    @IBOutlet private var markButton: LargeButton!
    @IBOutlet private var deadlineLabel: UILabel!

    private var id: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
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

    private func updateDeadlineTextColor(deadline: Date) {
        deadlineLabel.textColor = deadline > Date() ? UIColor.Color.black : UIColor.Color.exit
    }

    func setup(item: MainDataItem) {
        id = item.id
        titleLabel.text = item.title
        deadlineLabel.text = DateFormatter.default.string(from: item.date)
        updateDeadlineTextColor(deadline: item.date)

        setMark(isCompleted: item.isCompleted)
    }

    func setMark(isCompleted: Bool) {
        let markImage = isCompleted ? UIImage.MainItemCell.iconTrue : UIImage.MainItemCell.iconFalse
        markButton.setImage(markImage, for: .normal)
    }

    var action: ((String) -> Void)?

    @IBAction private func didTapMarkButton() {
        action?(id ?? "")
    }
}
