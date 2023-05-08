import Foundation
import ReSwift

extension Reducers {
    static func signedInReducer(action: Action, state: SignedInViewControllerState) -> SignedInViewControllerState {
        return SignedInViewControllerState(
            userSession: state.userSession,
            newRideState: Reducers.newRideReducer(action: action, state: state.newRideState),
            viewingProfile: Reducers.viewingProfileReducer(action: action, state: state.viewingProfile),
            profileViewControllerState: Reducers.profileReducer(action: action, state: state.profileViewControllerState))
    }
    
    private static func viewingProfileReducer(action: Action, state: Bool?) -> Bool {
        var state = state ?? false
        switch action {
        case _ as SignedInActions.ViewProfile:
            state = true
        case _ as SignedInActions.DismissProfile:
            state = false
        default:
            break
        }
        return state
    }
}
