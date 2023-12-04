import Foundation

enum L10n {
    enum Auth {
        static let title = NSLocalizedString("auth.title", comment: "")
        static let emailTextField = NSLocalizedString("auth.email-text-field", comment: "")
        static let passwordTextField = NSLocalizedString("auth.password-text-field", comment: "")
        static let signInButton = NSLocalizedString("auth.sign-in-button", comment: "")
        static let signUpButton = NSLocalizedString("auth.sign-up-button", comment: "")
    }
    
    enum SignUp {
        static let title = NSLocalizedString("sign-up.title", comment: "")
        static let usernameTextField = NSLocalizedString("sign-up.username-text-field", comment: "")
        static let emailTextField = NSLocalizedString("sign-up.email-text-field", comment: "")
        static let passwordTextField = NSLocalizedString("sign-up.password-text-field", comment: "")
        static let signUpButton = NSLocalizedString("sign-up.sign-up-button", comment: "")
    }
    
    enum ErrorValidation {
        static let emptyField = NSLocalizedString("error-validation.empty-field", comment: "")
        static let email = NSLocalizedString("error-validation.email", comment: "")
        static let username = NSLocalizedString("error-validation.username", comment: "")
        static let password = NSLocalizedString("error-validation.password", comment: "")
    }  
    
    enum Main {
        static let title = NSLocalizedString("main.title", comment: "")
        static let profileButton = NSLocalizedString("main.profile-button", comment: "")
        static let emptyLabel = NSLocalizedString("main.empty-label", comment: "")
        static let emptyButton = NSLocalizedString("main.empty-button", comment: "")
        static let dateFormat = NSLocalizedString("main.date-format", comment: "")
        static let errorNoConnectionLabel = NSLocalizedString("main.error-no-connection-label", comment: "")
        static let errorSomethingWentWrongLabel = NSLocalizedString("main.error-something-went-wrong-label", comment: "")
        static let errorUpdateButton = NSLocalizedString("main.error-update-button", comment: "")
    }
    
    enum NewItem {
        static let title = NSLocalizedString("new-item.title", comment: "")
        static let titleTextViewLabel = NSLocalizedString("new-item.title-text-view-label", comment: "")
        static let descriptionTextViewLabel = NSLocalizedString("new-item.description-text-view-label", comment: "")
        static let deadlineLabel = NSLocalizedString("new-item.deadline-label", comment: "")
        static let createButton = NSLocalizedString("new-item.create-button", comment: "")
    }
    
    enum EditItem {
        static let title = NSLocalizedString("edit-item.title", comment: "")
        static let deleteButton = NSLocalizedString("edit-item.delete-button", comment: "")
    }
    
    enum NetworkError {
        static let wrongStatusCode = NSLocalizedString("network-error.wrong-status-code", comment: "")
        static let wrongURL = NSLocalizedString("network-error.wrong-url", comment: "")
        static let wrongResponse = NSLocalizedString("network-error.wrong-response", comment: "")
    }
    
    enum Alert {
        static let title = NSLocalizedString("alert.title", comment: "")
        static let closeButton = NSLocalizedString("alert.close-button", comment: "")
    }
}
