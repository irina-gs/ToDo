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

    @IBOutlet private var buttonKeyboardConstraint: NSLayoutConstraint!

    weak var delegate: NewItemViewControllerDelegate?

    var selectedItem: MainDataItem?

    private lazy var heightButtonConstraint = createButton.heightAnchor.constraint(equalToConstant: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextView.setupLabel(label: L10n.NewItem.titleTextViewLabel)
        descriptionTextView.setupLabel(label: L10n.NewItem.descriptionTextViewLabel)

        deadlineLabel.text = L10n.NewItem.deadlineLabel
        setupDatePicker()

        if let selectedItem {
            navigationItem.title = L10n.EditItem.title

            let deleteButton = UIBarButtonItem(title: L10n.EditItem.deleteButton, style: .plain, target: self, action: #selector(didTapDeleteButton))
            deleteButton.tintColor = UIColor.Color.error
            navigationItem.rightBarButtonItem = deleteButton

            titleTextView.setupTextView(text: selectedItem.title)
            descriptionTextView.setupTextView(text: selectedItem.description)
            deadlineDatePicker.date = selectedItem.date

            buttonKeyboardConstraint.constant = 0
            heightButtonConstraint.isActive = true
            createButton.isHidden = true
        } else {
            navigationItem.title = L10n.NewItem.title

            buttonKeyboardConstraint.constant = 16
            heightButtonConstraint.isActive = false
            createButton.isHidden = false
            createButton.setTitle(L10n.NewItem.createButton, for: .normal)
        }

        addTapToHideKeyboardGesture()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(false)
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

    @IBAction private func didTapCreateButton() {
        guard titleTVValidation(), let title = titleTextView.text, let description = descriptionTextView.text else {
            return
        }

        Task {
            do {
                _ = try await NetworkManager.shared.newTodo(title: title, description: description, date: deadlineDatePicker.date)
                delegate?.didSelect(self)
                navigationController?.popViewController(animated: true)
            } catch {
                DispatchQueue.main.async {
                    self.showSnackBar()
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
    private func didTapDeleteButton() {
        guard let selectedItem else {
            return
        }

        Task {
            do {
                _ = try await NetworkManager.shared.deleteTodo(id: selectedItem.id)
                delegate?.didSelect(self)
                navigationController?.popViewController(animated: true)
            } catch {
                DispatchQueue.main.async {
                    self.showSnackBar()
                }
            }
        }
    }
}
