//
//  NewItemViewController.swift
//  todo
//
//  Created by admin on 16.11.2023.
//

import UIKit

protocol NewItemViewControllerDelegate: AnyObject {
    func didSelect(_ vc: NewItemViewController)
}

final class NewItemViewController: ParentViewController {
    @IBOutlet private var titleTextView: TextView!
    @IBOutlet private var descriptionTextView: TextView!
    @IBOutlet private var deadlineLabel: UILabel!
    @IBOutlet private var datePickerView: UIView!
    @IBOutlet private var deadlineDatePicker: UIDatePicker!
    @IBOutlet private var createButton: PrimaryButton!
        
    weak var delegate: NewItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = L10n.NewItem.title
        
        titleTextView.setup(label: L10n.NewItem.titleTextViewLabel)
        descriptionTextView.setup(label: L10n.NewItem.descriptionTextViewLabel)
        
        deadlineLabel.text = L10n.NewItem.deadlineLabel
        setupDatePicker()
        
        createButton.setTitle(L10n.NewItem.createButton, for: .normal)

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
                    _ = try await NetworkManager.shared.newTodo(title: titleTextView.text ?? "", description: descriptionTextView.text ?? "", date: deadlineDatePicker.date)
                    
                    delegate?.didSelect(self)
                    
                    navigationController?.popViewController(animated: true)
                    
                } catch {
                    let alertVC = UIAlertController(title: L10n.Alert.title, message: error.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: L10n.Alert.closeButton, style: .cancel))
                    
                    DispatchQueue.main.async {
                        self.present(alertVC, animated: true)
                    }
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
}
