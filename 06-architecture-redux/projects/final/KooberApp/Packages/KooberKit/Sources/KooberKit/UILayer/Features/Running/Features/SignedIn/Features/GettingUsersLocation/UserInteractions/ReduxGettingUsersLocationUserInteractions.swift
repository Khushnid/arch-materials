import Foundation
import ReSwift

public class ReduxGettingUsersLocationUserInteractions: GettingUsersLocationUserInteractions {
    
    // MARK: - Properties
    let actionDispatcher: ActionDispatcher
    let locator: Locator
    
    // MARK: - Methods
    public init(actionDispatcher: ActionDispatcher,
                locator: Locator) {
        self.actionDispatcher = actionDispatcher
        self.locator = locator
    }
    
    public func getUsersLocation() {
        locator
            .getUsersCurrentLocation()
            .done(pickUpUser(at:))
            .catch { error in
                let errorMessage = ErrorMessage(title: "Error Getting Location",
                                                message: "Could not get your location. Please check location settings and try again.")
                let action = GettingUsersLocationActions.FailedGettingUsersLocation(errorMessage: errorMessage)
                self.actionDispatcher.dispatch(action)
            }
    }
    
    private func pickUpUser(at location: Location) {
        let action = SignedInActions.PickUpLocationDetermined(pickupLocation: location)
        actionDispatcher.dispatch(action)
    }
    
    public func finishedPresenting(_ errorMessage: ErrorMessage) {
        let action = GettingUsersLocationActions.FinishedPresentingError(errorMessage: errorMessage)
        actionDispatcher.dispatch(action)
    }
}
