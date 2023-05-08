import Foundation

struct SignInLogic {
    
    // MARK: - Methods
    static func indicateSigningIn(viewState: inout SignInViewState) {
        viewState.emailInputEnabled = false
        viewState.passwordInputEnabled = false
        viewState.signInButtonEnabled = false
        viewState.signInActivityIndicatorAnimating = true
    }
    
    static func resetAfterErrorPresentation(viewState: inout SignInViewState) {
        viewState.emailInputEnabled = true
        viewState.passwordInputEnabled = true
        viewState.signInButtonEnabled = true
        viewState.signInActivityIndicatorAnimating = false
    }
}

func indicateErrorSigningIn(viewControllerState: inout SignInViewControllerState) {
    let errorMessage = ErrorMessage(title: "Sign In Failed",
                                    message: "Could not sign in.\nPlease try again.")
    viewControllerState.errorsToPresent.insert(errorMessage)
}
