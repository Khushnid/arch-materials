import Foundation

public enum NewRideState: Equatable {
    case gettingUsersLocation(GettingUsersLocationViewControllerState)
    case requestingNewRide(pickupLocation: Location, PickMeUpViewControllerState)
    case waitingForPickup
    
    public static func sameCase(lhs: NewRideState, rhs: NewRideState) -> Bool {
        switch (lhs, rhs) {
        case (.gettingUsersLocation, .gettingUsersLocation):
            return true
        case (.requestingNewRide, .requestingNewRide):
            return true
        case (.waitingForPickup, .waitingForPickup):
            return true
        case (.gettingUsersLocation, _),
            (.requestingNewRide, _),
            (.waitingForPickup, _):
            return false
        }
    }
}
