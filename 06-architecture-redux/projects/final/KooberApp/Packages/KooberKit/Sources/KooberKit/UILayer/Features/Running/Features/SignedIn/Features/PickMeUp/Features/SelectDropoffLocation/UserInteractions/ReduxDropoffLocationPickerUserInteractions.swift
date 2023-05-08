import Foundation
import ReSwift

public class ReduxDropoffLocationPickerUserInteractions: DropoffLocationPickerUserInteractions {
    
    // MARK: - Properties
    let actionDispatcher: ActionDispatcher
    let locationRepository: LocationRepository
    
    // MARK: - Methods
    public init(actionDispatcher: ActionDispatcher,
                locationRepository: LocationRepository) {
        self.actionDispatcher = actionDispatcher
        self.locationRepository = locationRepository
    }
    
    public func cancelDropoffLocationPicker() {
        let action = DropoffLocationPickerActions.CancelDropoffLocationPicker()
        actionDispatcher.dispatch(action)
    }
    
    public func searchForDropoffLocations(using query: String, for pickupLocation: Location) {
        let searchID = UUID()
        let newSearchAction = DropoffLocationPickerActions.NewLocationSearch(searchID: searchID)
        actionDispatcher.dispatch(newSearchAction)
        
        locationRepository
            .searchForLocations(using: query, pickupLocation: pickupLocation)
            .done { [weak self] searchResults in
                self?.update(searchResults: searchResults, for: searchID)
            }
            .catch { error in
                let errorMessage = ErrorMessage(title: "Location Error",
                                                message: "Sorry, we ran into an unexpected error while getting locations.\nPlease try again.")
                let action = DropoffLocationPickerActions.LocationSearchFailed(errorMessage: errorMessage)
                self.actionDispatcher.dispatch(action)
            }
    }
    
    private func update(searchResults: [NamedLocation], for searchID: UUID) {
        let action = DropoffLocationPickerActions.LocationSearchComplete(searchID: searchID, searchResults: searchResults)
        actionDispatcher.dispatch(action)
    }
    
    public func select(dropoffLocation: Location) {
        let action = DropoffLocationPickerActions.DropoffLocationSelected(dropoffLocation: dropoffLocation)
        actionDispatcher.dispatch(action)
    }
    
    public func finishedPresenting(_ errorMessage: ErrorMessage) {
        let action = DropoffLocationPickerActions.FinishedPresentingError(errorMessage: errorMessage)
        return actionDispatcher.dispatch(action)
    }
}
