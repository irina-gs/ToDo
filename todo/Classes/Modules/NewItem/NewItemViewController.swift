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
    @IBOutlet private var textView1: UIView!
    @IBOutlet private var textView2: UIView!
    @IBOutlet private var label: UILabel!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var createButton: UIButton!
    
    weak var delegate: NewItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Новая запись"
    }
    
    @IBAction private func didTab() {
        delegate?.didSelect(self, data: NewItemData(title: "textView1.text", description: "textView2.text", deadline: datePicker.date))
        navigationController?.popViewController(animated: true)
    }
}
