import Foundation

public enum PickMeUpState: Equatable {
    
    case initial
    case selectDropoffLocation(DropoffLocationPickerViewControllerState)
    case selectRideOption(RideOptionPickerViewControllerState, confirmingRequest: Bool)
    case final
    
    public static func sameCase(lhs: PickMeUpState, rhs: PickMeUpState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case (.selectDropoffLocation, .selectDropoffLocation):
            return true
        case (.selectRideOption, .selectRideOption):
            return true
        case (.final, .final):
            return true
        case (.initial, _),
            (.selectDropoffLocation,_),
            (.selectRideOption,_),
            (.final,_):
            return false
        }
    }
}

public enum NewRideRequestSendingState: Equatable {
    
    case notSending
    case send(NewRideRequest)
}
