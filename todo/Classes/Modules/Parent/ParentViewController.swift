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

    static func logOutAccount() {
        UserManager.shared.reset()
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        DispatchQueue.main.async {
            UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.last?.rootViewController = storyboard.instantiateInitialViewController()
        }
    }

    func showSnackBar(message: String) {
        let snackBar = SnackBarView()
        snackBar.setupMessage(message: message)
        snackBar.show(view: view)
    }
}
