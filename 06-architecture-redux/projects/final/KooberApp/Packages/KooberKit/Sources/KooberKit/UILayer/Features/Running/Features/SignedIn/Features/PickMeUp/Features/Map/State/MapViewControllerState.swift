import Foundation

public struct MapViewControllerState: Equatable {

  // MARK: - Properties
  public internal(set) var pickupLocation: Location
  public internal(set) var dropoffLocation: Location?
}
