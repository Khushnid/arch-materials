import Foundation
import ReSwift

struct RideOptionPickerActions {
    
    struct RideOptionsLoaded: Action {
        
        // MARK: - Properties
        let rideOptions: RideOptionSegmentedControlState
    }
    
    struct RideOptionSelected: Action {
        
        // MARK: - Properties
        let rideOptionID: RideOptionID
    }
    
    struct FailedToLoadRideOptions: Action {
        
        // MARK: - Properties
        let errorMessage: ErrorMessage
    }
    
    struct FinishedPresentingError: Action {
        
        // MARK: - Properties
        let errorMessage: ErrorMessage
    }
}
