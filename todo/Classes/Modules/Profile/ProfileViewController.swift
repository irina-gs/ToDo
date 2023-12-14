//
//  ProfileViewController.swift
//  todo
//
//  Created by admin on 08.12.2023.
//

import UIKit

final class ProfileViewController: ParentViewController {
    private var user: UserResponse?

    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var exitButton: TextButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = L10n.Profile.title

        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true

        usernameLabel.font = .systemFont(ofSize: 16, weight: .bold)

        Task {
            do {
                user = try await NetworkManager.shared.getUser()
                usernameLabel.text = user?.name
            } catch {
                DispatchQueue.main.async {
                    self.showSnackBar(message: error.localizedDescription)
                }
            }
        }

        exitButton.setTitle(L10n.Profile.exitButton, for: .normal)
        exitButton.setMode(mode: .destructive)
    }

    @IBAction private func didTapExitButton() {
        let alertVC = UIAlertController(title: L10n.Profile.alertTitle, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: L10n.Profile.alertExitButton, style: .destructive, handler: { _ in
            ProfileViewController.logOutAccount()
        }))
        alertVC.addAction(UIAlertAction(title: L10n.Profile.alertCancelButton, style: .cancel))
        present(alertVC, animated: true)
    }
}
