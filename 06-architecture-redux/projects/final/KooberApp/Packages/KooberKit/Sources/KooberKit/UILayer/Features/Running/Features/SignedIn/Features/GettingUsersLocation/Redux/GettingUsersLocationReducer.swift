import Foundation
import ReSwift

extension Reducers {
    static func gettingUsersLocationReducer(action: Action, state: GettingUsersLocationViewControllerState?) -> GettingUsersLocationViewControllerState {
        var state = state ?? GettingUsersLocationViewControllerState(errorsToPresent: [])
        
        switch action {
        case let action as GettingUsersLocationActions.FailedGettingUsersLocation:
            state.errorsToPresent.insert(action.errorMessage)
        case let action as GettingUsersLocationActions.FinishedPresentingError:
            state.errorsToPresent.remove(action.errorMessage)
        default:
            break
        }
        
        return state
    }
}
