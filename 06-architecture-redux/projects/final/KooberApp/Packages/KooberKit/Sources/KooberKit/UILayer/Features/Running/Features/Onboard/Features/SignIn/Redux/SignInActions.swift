import Foundation
import ReSwift

struct SignInActions {
    
    // Internal
    struct SigningIn: Action {}
    
    struct SignInFailed: Action {
        let errorMessage: ErrorMessage
    }
    
    struct FinishedPresentingError: Action {
        let errorMessage: ErrorMessage
    }
    
    // External
    struct SignedIn: Action {
        let userSession: UserSession
    }
}
