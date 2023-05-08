import Foundation

public struct SignedInViewControllerState: Equatable {
    
    // MARK: - Properties
    public internal(set) var userSession: UserSession
    public internal(set) var newRideState: NewRideState
    public internal(set) var viewingProfile: Bool
    public internal(set) var profileViewControllerState: ProfileViewControllerState
}
