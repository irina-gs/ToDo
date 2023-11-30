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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
                
        addTapToHideKeyboardGesture()
    }
    
    private func setupDatePicker() {
        deadlineDatePicker.tintColor = UIColor.Color.Default.SystemRed.light
        deadlineDatePicker.calendar.firstWeekday = 1
        deadlineDatePicker.locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        let cornerRadius: CGFloat = 13
        datePickerView.layer.cornerRadius = cornerRadius
        
        let shadowPath = UIBezierPath(roundedRect: datePickerView.bounds, cornerRadius: cornerRadius)
        datePickerView.layer.shadowPath = shadowPath.cgPath
        datePickerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        datePickerView.layer.shadowOpacity = 1
        datePickerView.layer.shadowRadius = 60
        datePickerView.layer.shadowOffset = CGSize(width: 0, height: 10)
    }
    
    @IBAction private func didTabCreateButton() {
        if titleTVValidation() {
            Task {
                do {
                    let response = try await NetworkManager.shared.newTodo(title: titleTextView.text ?? "", description: descriptionTextView.text ?? "", date: deadlineDatePicker.date)
                    
                    delegate?.didSelect(self, data: NewItemData(title: titleTextView.text ?? "", description: descriptionTextView.text ?? "", deadline: deadlineDatePicker.date))
                    navigationController?.popViewController(animated: true)
                    
                } catch {
                    let alertVC = UIAlertController(title: "Ошибка!", message: error.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
                    present(alertVC, animated: true)
                }
            }
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
        bottomConstraint.constant = 16
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }

    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
