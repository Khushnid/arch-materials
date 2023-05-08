import Foundation
import ReSwift

extension Reducers {
    static func appRunningReducer(action: Action, state: AppRunningState?) -> AppRunningState {
        var state = state ?? .onboarding(.welcoming)
        
        switch state {
        case let .onboarding(onboardingState):
            state = .onboarding(Reducers.onboardingReducer(action: action,
                                                           state: onboardingState))
        case let .signedIn(signedInViewControllerState, userSession):
            state = .signedIn(Reducers.signedInReducer(action: action, state: signedInViewControllerState),
                              userSession)
        }
        
        switch action {
        case let action as SignInActions.SignedIn:
            let initialSignedInViewControllerState = SignedInViewControllerState(userSession: action.userSession,
                                                                                 newRideState: .gettingUsersLocation(GettingUsersLocationViewControllerState(errorsToPresent: [])),
                                                                                 viewingProfile: false,
                                                                                 profileViewControllerState: ProfileViewControllerState(profile: action.userSession.profile, errorsToPresent: []))
            state = .signedIn(Reducers.signedInReducer(action: action, state: initialSignedInViewControllerState),
                              action.userSession)
        case _ as AppRunningActions.SignOut:
            state = .onboarding(.welcoming)
        default:
            break
        }
        
        return state
    }
}
