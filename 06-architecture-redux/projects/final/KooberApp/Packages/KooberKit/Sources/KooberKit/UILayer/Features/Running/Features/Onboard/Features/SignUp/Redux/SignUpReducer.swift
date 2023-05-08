import Foundation
import ReSwift

extension Reducers {
    static func signUpReducer(action: Action, state: SignUpViewControllerState?) -> SignUpViewControllerState {
        var state = state ?? SignUpViewControllerState()
        
        switch action {
        case let action as SignUpActions.SignUpFailed:
            state.errorsToPresent.insert(action.errorMessage)
        case let action as SignUpActions.FinishedPresentingError:
            state.errorsToPresent.remove(action.errorMessage)
        default:
            break
        }
        
        return state
    }
}
