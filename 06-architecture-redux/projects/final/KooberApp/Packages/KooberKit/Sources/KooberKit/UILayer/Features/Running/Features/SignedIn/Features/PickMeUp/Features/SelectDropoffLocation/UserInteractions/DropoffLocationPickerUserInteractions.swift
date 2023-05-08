import Foundation

public protocol DropoffLocationPickerUserInteractions {
    
    func cancelDropoffLocationPicker()
    func searchForDropoffLocations(using query: String, for pickupLocation: Location)
    func select(dropoffLocation: Location)
    func finishedPresenting(_ errorMessage: ErrorMessage)
}
