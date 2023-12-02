//
//  EmptyViewController.swift
//  todo
//
//  Created by admin on 14.11.2023.
//

import UIKit

final class EmptyViewController: ParentViewController {
//    enum CustomError: Error {
//        case noConnection
//        case somethingWentWrong
//    }
    
    enum State {
        case empty, error(Error)
    }
    
    @IBOutlet private var emptyImageView: UIImageView!
    @IBOutlet private var emptyLabel: UILabel!
    @IBOutlet private var emptyButton: PrimaryButton!
    @IBOutlet private var updateButton: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        updateState()
    }
    
    var state: State = .empty {
        didSet {
            guard view.window != nil else {
                return
            }
            updateState()
        }
    }
    
    private func updateState() {
        switch state {
        case .empty:
            emptyButton.isHidden = false
            updateButton.isHidden = true
            emptyImageView.image = UIImage.Main.empty
            emptyLabel.text = L10n.Main.emptyLabel
            emptyButton.setTitle(L10n.Main.emptyButton, for: .normal)
        case let .error(error):
            updateButton.isHidden = false
            emptyButton.isHidden = true
            updateButton.setTitle(L10n.Main.errorUpdateButton, for: .normal)
            updateButton.setMode(mode: .small)
            
            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                emptyImageView.image = UIImage.Main.errorNoConnection
                emptyLabel.text = L10n.Main.errorNoConnectionLabel
            } else {
                emptyImageView.image = UIImage.Main.errorSomethingWentWrong
                emptyLabel.text = L10n.Main.errorSomethingWentWrongLabel
            }
        }
    }
    
    var action: (() -> Void)?
    
    @IBAction private func didTapEmptyButton() {
        action?()
    }
    
    @IBAction private func didTapUpdateButton() {
        action?()
    }
}
