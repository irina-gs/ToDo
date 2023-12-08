//
//  ParentViewController.swift
//  todo
//
//  Created by admin on 02.11.2023.
//

import UIKit

class ParentViewController: UIViewController {
    deinit {
        print("\(String(describing: type(of: self))) realased")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonDisplayMode = .minimal
    }

    func showAlertVC(massage: String) {
        let alertVC = UIAlertController(title: L10n.Alert.title, message: massage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: L10n.Alert.closeButton, style: .cancel))
        present(alertVC, animated: true)
    }
}
