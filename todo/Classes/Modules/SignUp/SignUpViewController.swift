//
//  SignUpViewController.swift
//  todo
//
//  Created by admin on 06.11.2023.
//

import Dip
import UIKit

final class SignUpViewController: ParentViewController {
    @Injected private var networkManager: SignUpManager!

    @IBOutlet private var usernameTextField: TextInput!
    @IBOutlet private var emailTextField: TextInput!
    @IBOutlet private var passwordTextField: TextInput!

    @IBOutlet private var signUpButton: PrimaryButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = L10n.SignUp.title
        navigationController?.navigationBar.prefersLargeTitles = true

        usernameTextField.setup(placeholder: L10n.SignUp.usernameTextField, text: nil)
        emailTextField.setup(placeholder: L10n.SignUp.emailTextField, text: nil)
        passwordTextField.setup(placeholder: L10n.SignUp.passwordTextField, text: nil)

        signUpButton.setTitle(L10n.SignUp.signUpButton, for: .normal)

        passwordTextField.enableSecurityMode()

        addTapToHideKeyboardGesture()
    }

    @IBAction private func didTabSignUp() {
        let usernameTFIsValid = usernameTFValidation()
        let emailTFIsValid = emailTFValidation()
        let passwordTFIsValid = passwordTFValidation()

        if usernameTFIsValid && emailTFIsValid && passwordTFIsValid {
            Task {
                do {
                    _ = try await networkManager.signUp(name: usernameTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? "")

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateInitialViewController()
                    view.window?.rootViewController = vc
                } catch {
                    DispatchQueue.main.async {
                        self.showSnackBar(message: error.localizedDescription)
                    }
                }
            }
        }
    }

    private func usernameTFValidation() -> Bool {
        if !ValidationManager.isValid(commonText: usernameTextField.text, symbolsCount: 0) {
            if ValidationManager.isValid(commonText: usernameTextField.text, symbolsCount: 70) {
                return true
            } else {
                usernameTextField.show(error: L10n.ErrorValidation.username)
                return false
            }
        } else {
            usernameTextField.show(error: L10n.ErrorValidation.emptyField)
            return false
        }
    }

    private func emailTFValidation() -> Bool {
        if !ValidationManager.isValid(commonText: emailTextField.text, symbolsCount: 0) {
            if ValidationManager.isValid(email: emailTextField.text) {
                return true
            } else {
                emailTextField.show(error: L10n.ErrorValidation.email)
                return false
            }
        } else {
            emailTextField.show(error: L10n.ErrorValidation.emptyField)
            return false
        }
    }

    private func passwordTFValidation() -> Bool {
        if !ValidationManager.isValid(commonText: passwordTextField.text, symbolsCount: 0) {
            if ValidationManager.isValid(commonText: passwordTextField.text, symbolsCount: 256) {
                return true
            } else {
                passwordTextField.show(error: L10n.ErrorValidation.password)
                return false
            }
        } else {
            passwordTextField.show(error: L10n.ErrorValidation.emptyField)
            return false
        }
    }
}
