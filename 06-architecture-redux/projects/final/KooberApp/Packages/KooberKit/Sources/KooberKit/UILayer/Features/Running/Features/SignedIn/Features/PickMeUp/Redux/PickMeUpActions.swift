import Foundation
import ReSwift

struct PickMeUpActions {
    
    struct GoToDropoffLocationPicker: Action {}
    
    struct ConfirmedNewRideRequest: Action {}
    
    struct NewRideRequestSent: Action {}
    
    struct FailedToSendNewRideRequest: Action {
        
        // MARK: - Properties
        let errorMessage: ErrorMessage
    }
    
    struct FinishedPresentingNewRideRequestError: Action {
        
        // MARK: - Properties
        let errorMessage: ErrorMessage
    }
}
