import Foundation

public struct SignedInGetters {
    
    // MARK: - Properties
    public let getSignedInState: (AppState) -> ScopedState<SignedInViewControllerState>
    
    // MARK: - Methods
    public init(getSignedInState: @escaping (AppState) -> ScopedState<SignedInViewControllerState>) {
        self.getSignedInState = getSignedInState
    }
    
    public func getGettingUsersLocationViewControllerState(appState: AppState) -> ScopedState<GettingUsersLocationViewControllerState> {
        let signedInScopedState = getSignedInState(appState)
        guard case .inScope(let signedInViewControllerState) = signedInScopedState else {
            return .outOfScope
        }
        guard case let .gettingUsersLocation(gettingUsersLocationViewControllerState) = signedInViewControllerState.newRideState else {
            return .outOfScope
        }
        return .inScope(gettingUsersLocationViewControllerState)
    }
    
    public func getPickMeUpViewControllerState(appState: AppState) -> ScopedState<PickMeUpViewControllerState> {
        let signedInScopedState = getSignedInState(appState)
        guard case .inScope(let signedInViewControllerState) = signedInScopedState else {
            return .outOfScope
        }
        guard case let .requestingNewRide(_, pickMeUpViewControllerState) = signedInViewControllerState.newRideState else {
            return .outOfScope
        }
        return .inScope(pickMeUpViewControllerState)
    }
    
    public func getProfileViewControllerState(appState: AppState) -> ScopedState<ProfileViewControllerState> {
        let signedInScopedState = getSignedInState(appState)
        guard case .inScope(let signedInViewControllerState) = signedInScopedState else {
            return .outOfScope
        }
        return .inScope(signedInViewControllerState.profileViewControllerState)
    }
}
