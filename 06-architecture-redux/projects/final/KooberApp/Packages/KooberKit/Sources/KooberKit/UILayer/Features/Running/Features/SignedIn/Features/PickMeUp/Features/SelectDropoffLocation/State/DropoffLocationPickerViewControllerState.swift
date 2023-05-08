import Foundation

public struct DropoffLocationPickerViewControllerState: Equatable {

  // MARK: - Properties
  public internal(set) var pickupLocation: Location
  public internal(set) var searchResults: [NamedLocation]
  public internal(set) var currentSearchID: UUID?
  public internal(set) var errorsToPresent: Set<ErrorMessage>
}
 
