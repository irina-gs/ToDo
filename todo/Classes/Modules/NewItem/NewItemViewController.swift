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
    @IBOutlet private var datePickerView: UIView!
    @IBOutlet private var deadlineDatePicker: UIDatePicker!
    @IBOutlet private var createButton: PrimaryButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    weak var delegate: NewItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = L10n.NewItem.title
        
        titleTextView.setup(label: L10n.NewItem.titleTextViewLabel)
        descriptionTextView.setup(label: L10n.NewItem.descriptionTextViewLabel)
        
        deadlineLabel.text = L10n.NewItem.deadlineLabel
        setupDatePicker()
        
        createButton.setTitle(L10n.NewItem.createButton, for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
                
        addTapToHideKeyboardGesture()
    }
    
    private func setupDatePicker() {
        deadlineDatePicker.tintColor = UIColor.Color.Default.SystemRed.light
        deadlineDatePicker.calendar.firstWeekday = 1
        deadlineDatePicker.locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        datePickerView.layer.cornerRadius = 13
        datePickerView.layer.shadowColor = UIColor.Color.black.cgColor
        datePickerView.layer.shadowOpacity = 0.1
        datePickerView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    @IBAction private func didTab() {
        if titleTVValidation() {
            delegate?.didSelect(self, data: NewItemData(title: titleTextView.text ?? "", description: descriptionTextView.text ?? "", deadline: deadlineDatePicker.date))
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func titleTVValidation() -> Bool {
        if !ValidationManager.isValid(commonText: titleTextView.text, symbolsCount: 0) {
            return true
        } else {
            titleTextView.show(error: L10n.ErrorValidation.emptyField)
            return false
        }
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            bottomConstraint.constant = keyboardHeight - self.view.safeAreaInsets.bottom + 16
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            
        }
    }

    @objc
    private func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            _ = keyboardSize.height
            bottomConstraint.constant = 16
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
