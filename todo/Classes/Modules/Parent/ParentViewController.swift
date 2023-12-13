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

    func showSnackBar(message: String) {
        let snackBar = SnackBarView()
        snackBar.setupMessage(message: message)
        snackBar.show(view: view)
    }
}
