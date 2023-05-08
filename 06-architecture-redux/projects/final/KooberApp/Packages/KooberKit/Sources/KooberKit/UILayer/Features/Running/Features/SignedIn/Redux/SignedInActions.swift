import Foundation
import ReSwift

struct SignedInActions {
    
    struct PickUpLocationDetermined: Action {
        
        // MARK: - Properties
        let pickupLocation: Location
    }
    
    struct ViewProfile: Action {}
    
    struct DismissProfile: Action {}
    
    struct FinishedRequestingNewRide: Action {}
    
    struct StartNewRideRequest: Action {}
}
