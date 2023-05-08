import Foundation
import CoreGraphics
import PromiseKit

public class ReduxRideOptionPickerUserInteractions: RideOptionPickerUserInteractions {
    
    // MARK: - Properties
    let actionDispatcher: ActionDispatcher
    let rideOptionRepository: RideOptionRepository
    
    // MARK: - Methods
    public init(actionDispatcher: ActionDispatcher,
                rideOptionRepository: RideOptionRepository) {
        self.actionDispatcher = actionDispatcher
        self.rideOptionRepository = rideOptionRepository
    }
    
    public func loadRideOptions(availableAt pickupLocation: Location, screenScale: CGFloat) {
        rideOptionRepository
            .readRideOptions(availableAt: pickupLocation)
            .then { (rideOptions: [RideOption]) -> Promise<RideOptionPickerRideOptions> in
                let pickerRideOptions = RideOptionPickerRideOptions(rideOptions: rideOptions)
                return Promise.value(pickerRideOptions)
            }
            .then { (pickerRideOptions: RideOptionPickerRideOptions) -> Promise<[RideOptionSegmentState]>  in
                let factory = RideOptionSegmentsFactory(state: pickerRideOptions)
                let segments = factory.makeSegments(screenScale: screenScale)
                return Promise.value(segments)
            }
            .done { segments in
                let rideOptions = RideOptionSegmentedControlState(segments: segments)
                let action = RideOptionPickerActions.RideOptionsLoaded(rideOptions: rideOptions)
                self.actionDispatcher.dispatch(action)
            }
            .catch { error in
                let errorMessage = ErrorMessage(title: "Ride Option Error",
                                                message: "We're having trouble getting available ride options. Please start a new ride and try again.")
                let action = RideOptionPickerActions.FailedToLoadRideOptions(errorMessage: errorMessage)
                self.actionDispatcher.dispatch(action)
            }
    }
    
    public func select(rideOptionID: RideOptionID) {
        let action = RideOptionPickerActions.RideOptionSelected(rideOptionID: rideOptionID)
        actionDispatcher.dispatch(action)
    }
    
    public func finishedPresenting(_ errorMessage: ErrorMessage) {
        let action = RideOptionPickerActions.FinishedPresentingError(errorMessage: errorMessage)
        actionDispatcher.dispatch(action)
    }
}
