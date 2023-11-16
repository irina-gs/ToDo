//
//  EmptyViewController.swift
//  todo
//
//  Created by admin on 14.11.2023.
//

import UIKit

final class EmptyViewController: ParentViewController {
    enum State {
        case empty, error(Error)
    }
    
    @IBOutlet private var emptyImageView: UIImageView!
    @IBOutlet private var emptyLabel: UILabel!
    @IBOutlet private var emptyButton: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyButton.setTitle(L10n.Main.emptyButton, for: .normal)
        
        emptyImageView.image = UIImage.Main.empty
        updateState()
    }
    
    var action: (() -> Void)?
    
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
            emptyLabel.text = "Пустое состояние"
        case let .error(error):
            break
        }
    }
    
    @IBAction private func didTapEmptyButton() {
        action?()
    }
}
