//
//  ProfileViewController.swift
//  todo
//
//  Created by admin on 08.12.2023.
//

import Dip
import Kingfisher
import UIKit

final class ProfileViewController: ParentViewController {
    @Injected private var networkManager: ProfileManager!

    private var user: UserResponse?

    private let imagePicker = ImagePicker()

    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var exitButton: TextButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = L10n.Profile.title

        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImageView))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true

        usernameLabel.font = .systemFont(ofSize: 16, weight: .bold)

        getUser()

        exitButton.setTitle(L10n.Profile.exitButton, for: .normal)
        exitButton.setMode(mode: .destructive)
    }

    private func getUser() {
        Task {
            do {
                user = try await networkManager.getUser()
                usernameLabel.text = user?.name
                getUserPhoto()
            } catch {
                DispatchQueue.main.async {
                    self.showSnackBar(message: error.localizedDescription)
                }
            }
        }
    }

    private func getUserPhoto() {
        guard let user else {
            return
        }

        let modifier = AnyModifier { request in
            var request = request
            if let accessToken = UserManager.shared.accessToken {
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }
            return request
        }

        profileImageView.kf.cancelDownloadTask()
        let urlString = "\(PlistFiles.apiBaseUrl)\(PathURL.getUserPhoto(fileId: user.imageId).path)"
        profileImageView.kf.setImage(with: URL(string: urlString), options: [.requestModifier(modifier)])
    }

    @IBAction private func didTapExitButton() {
        let alertVC = UIAlertController(title: L10n.Profile.alertTitle, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: L10n.Profile.alertExitButton, style: .destructive, handler: { _ in
            ProfileViewController.logOutAccount()
        }))
        alertVC.addAction(UIAlertAction(title: L10n.Profile.alertCancelButton, style: .cancel))
        present(alertVC, animated: true)
    }

    @objc
    private func didTapProfileImageView() {
        imagePicker.show(in: self, completion: { [weak self] image in
            Task {
                do {
                    _ = try await self?.networkManager.uploadUserPhoto(image: image)
                    self?.profileImageView.image = image
                } catch {
                    DispatchQueue.main.async {
                        self?.showSnackBar(message: error.localizedDescription)
                    }
                }
            }
        })
    }
}
