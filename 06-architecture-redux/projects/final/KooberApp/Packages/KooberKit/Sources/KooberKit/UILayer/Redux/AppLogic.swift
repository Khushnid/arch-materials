import Foundation

struct AppLogic {
    // MARK: - Methods
    static func appState(for authenticationState: AuthenticationState) -> AppState {
        switch authenticationState {
        case .notSignedIn:
            return AppState.running(.onboarding(.welcoming))
        case .signedIn(let userSession):
            let initialNewRideState = NewRideState.gettingUsersLocation(GettingUsersLocationViewControllerState(errorsToPresent: []))
            let profileViewControllerState = ProfileViewControllerState(profile: userSession.profile, errorsToPresent: [])
            let initialSignedInViewControllerState =
            SignedInViewControllerState(userSession: userSession,
                                        newRideState: initialNewRideState,
                                        viewingProfile: false,
                                        profileViewControllerState: profileViewControllerState)
            return AppState.running(.signedIn(initialSignedInViewControllerState, userSession))
        }
    }
}
