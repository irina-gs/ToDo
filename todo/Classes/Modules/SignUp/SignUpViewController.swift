//
//  SignUpViewController.swift
//  todo
//
//  Created by admin on 06.11.2023.
//

import UIKit

final class SignUpViewController: ParentViewController {
    
    @IBOutlet weak var usernameTextField: TextInput!
    @IBOutlet weak var emailTextField: TextInput!
    @IBOutlet weak var passwordTextField: TextInput!
    
    @IBOutlet private var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = L10n.SignUp.title

        usernameTextField.setup(placeholder: L10n.SignUp.usernameTextField, text: nil)
        emailTextField.setup(placeholder: L10n.SignUp.emailTextField, text: nil)
        passwordTextField.setup(placeholder: L10n.SignUp.passwordTextField, text: nil)
        
        signUpButton.setTitle(L10n.SignUp.signUpButton, for: .normal)
        
        passwordTextField.enableSecurityMode()
        
        addTapToHideKeyboardGesture()
    }
    
    @IBAction private func didTabSignUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NavMainVC")
        view.window?.rootViewController = vc
    }
}
