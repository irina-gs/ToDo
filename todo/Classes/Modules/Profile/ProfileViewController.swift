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
    private var userPhoto = UIImage.Profile.empty

    private let imagePicker = ImagePicker()

    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var exitButton: TextButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = L10n.Profile.title

        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleToFill
        profileImageView.image = userPhoto

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImageView))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true

        usernameLabel.font = .systemFont(ofSize: 16, weight: .bold)

        getUser()

        exitButton.setTitle(L10n.Profile.exitButton, for: .normal)
        exitButton.setMode(mode: .destructive)
    }

    private func getUser() {
        showLoadingState()
        Task {
            do {
                user = try await networkManager.getUser()
                usernameLabel.text = user?.name
                getUserPhoto()
            } catch {
                DispatchQueue.main.async {
                    self.hideLoadingState()
                    self.showSnackBar(message: error.localizedDescription)
                }
            }
        }
    }

    private func getUserPhoto() {
        guard let user else {
            hideLoadingState()
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
        profileImageView.kf.setImage(with: URL(string: urlString), placeholder: UIImage.Profile.empty, options: [.requestModifier(modifier)])

        hideLoadingState(setDefaultImage: false)

        userPhoto = profileImageView.image ?? userPhoto
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
            self?.showLoadingState()
            Task {
                do {
                    _ = try await self?.networkManager.uploadUserPhoto(image: image)
                    self?.hideLoadingState(setDefaultImage: false)
                    self?.profileImageView.image = image
                    self?.userPhoto = image
                } catch {
                    DispatchQueue.main.async {
                        self?.hideLoadingState()
                        self?.showSnackBar(message: error.localizedDescription)
                    }
                }
            }
        })
    }

    private lazy var loader: LoadingIndicatorImageView = {
        let loader = LoadingIndicatorImageView(image: UIImage.Common.loaderLarge)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.isHidden = true

        profileImageView.addSubview(loader)

        NSLayoutConstraint.activate([
            loader.heightAnchor.constraint(equalTo: loader.widthAnchor),
            loader.heightAnchor.constraint(equalToConstant: 44),
            loader.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
        ])
        return loader
    }()

    private func showLoadingState() {
        loader.isHidden = false
        profileImageView.image = nil
        profileImageView.isUserInteractionEnabled = false
    }

    private func hideLoadingState(setDefaultImage: Bool = true) {
        loader.isHidden = true
        if setDefaultImage {
            profileImageView.image = userPhoto
        }
        profileImageView.isUserInteractionEnabled = true
    }
}
