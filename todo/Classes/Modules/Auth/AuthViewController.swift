//
//  ViewController.swift
//  todo
//
//  Created by admin on 26.10.2023.
//

import Combine
import UIKit

final class AuthViewController: ParentViewController {
    @IBOutlet private var emailTextField: TextInput!
    @IBOutlet private var passwordTextField: TextInput!

    @IBOutlet private var signInButton: PrimaryButton!
    @IBOutlet private var signUpButton: TextButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = L10n.Auth.title
        navigationController?.navigationBar.prefersLargeTitles = true

        emailTextField.setup(placeholder: L10n.Auth.emailTextField, text: nil)
        passwordTextField.setup(placeholder: L10n.Auth.passwordTextField, text: nil)
        
        signInButton.setTitle(L10n.Auth.signInButton, for: .normal)
        signUpButton.setTitle(L10n.Auth.signUpButton, for: .normal)

        passwordTextField.enableSecurityMode()
        
        addTapToHideKeyboardGesture()
    }
    
    @IBAction private func didTabSignIn() {
        let emailTFIsValid = emailTFValidation()
        let passwordTFIsValid = passwordTFValidation()
        
        if emailTFIsValid && passwordTFIsValid {
            Task {
                do {
                    let response = try await NetworkManager.shared.signIn(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
                    log.debug("\(response.accessToken)")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "NavMainVC")
                    view.window?.rootViewController = vc
                } catch {
                    
                    let alertVC = UIAlertController(title: "Ошибка!", message: error.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
                    present(alertVC, animated: true)
                }
            }
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
            return true
        } else {
            passwordTextField.show(error: L10n.ErrorValidation.emptyField)
            return false
        }
    }
}
