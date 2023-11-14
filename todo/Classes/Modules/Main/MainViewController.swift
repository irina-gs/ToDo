//
//  MainViewController.swift
//  todo
//
//  Created by admin on 31.10.2023.
//

import UIKit

final class MainViewController: ParentViewController {
    @IBOutlet private var emptyImageView: UIImageView!
    @IBOutlet private var emptyLabel: UILabel!
    @IBOutlet private var emptyButton: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = L10n.Main.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Main.profileButton, style: .plain, target: self, action: nil)
        
        emptyImageView.image = UIImage.Main.empty
        emptyLabel.text = L10n.Main.emptyLabel
        emptyButton.setTitle(L10n.Main.emptyButton, for: .normal)
    }
    
    @IBAction private func didTapEmtyButton() {}
}
