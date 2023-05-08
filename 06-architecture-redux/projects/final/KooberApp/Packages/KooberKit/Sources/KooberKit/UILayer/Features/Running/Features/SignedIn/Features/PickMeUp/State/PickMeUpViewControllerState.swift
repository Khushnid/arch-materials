import Foundation

public struct PickMeUpViewControllerState: Equatable {

  // MARK: - Properties
  public internal(set) var pickupLocation: Location
  public internal(set) var state: PickMeUpState
  public internal(set) var sendingState: NewRideRequestSendingState
  public internal(set) var progress: PickMeUpRequestProgress
  public internal(set) var mapViewControllerState: MapViewControllerState
  public internal(set) var shouldDisplayWhereTo: Bool
  public internal(set) var errorsToPresent: Set<ErrorMessage>
}
