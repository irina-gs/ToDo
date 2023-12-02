//
//  NewItemViewController.swift
//  todo
//
//  Created by admin on 16.11.2023.
//

import UIKit

struct NewItemData {
    let title: String
    let description: String
    let deadline: Date
}

protocol NewItemViewControllerDelegate: AnyObject {
    func didSelect(_ vc: NewItemViewController, data: NewItemData)
}

final class NewItemViewController: ParentViewController {
    @IBOutlet private var titleTextView: TextView!
    @IBOutlet private var descriptionTextView: TextView!
    @IBOutlet private var deadlineLabel: UILabel!
    @IBOutlet private var deadlineDatePicker: UIDatePicker!
    @IBOutlet private var createButton: PrimaryButton!
    
    weak var delegate: NewItemViewControllerDelegate?
    
    var selectedItem: MainDataItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = L10n.NewItem.title
        
        deadlineLabel.text = L10n.NewItem.deadlineLabel
        createButton.setTitle(L10n.NewItem.createButton, for: .normal)
        
        if let selectedItem {
            titleTextView.setupTextView(text: selectedItem.title)
        }
    }
    
    @IBAction private func didTab() {
        delegate?.didSelect(self, data: NewItemData(title: "titleTextView.text", description: "descriptionTextView.text", deadline: deadlineDatePicker.date))
        navigationController?.popViewController(animated: true)
    }
}
