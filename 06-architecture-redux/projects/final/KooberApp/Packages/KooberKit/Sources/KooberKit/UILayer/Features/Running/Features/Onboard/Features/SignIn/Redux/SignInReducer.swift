import Foundation
import ReSwift

extension Reducers {
    
    static func signInReducer(action: Action, state: SignInViewControllerState?) -> SignInViewControllerState {
        var state = state ?? SignInViewControllerState()
        
        switch action {
        case _ as SignInActions.SigningIn:
            SignInLogic.indicateSigningIn(viewState: &state.viewState)
        case let action as SignInActions.SignInFailed:
            state.errorsToPresent.insert(action.errorMessage)
        case let action as SignInActions.FinishedPresentingError:
            state.errorsToPresent.remove(action.errorMessage)
            SignInLogic.resetAfterErrorPresentation(viewState: &state.viewState)
        default:
            break
        }
        
        return state
    }
}
