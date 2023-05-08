import Foundation

public struct PickMeUpGetters {

  // MARK: - Properties
  public let getPickMeUpState: (AppState) -> ScopedState<PickMeUpViewControllerState>

  // MARK: - Methods
  public init(getPickMeUpState: @escaping (AppState) -> ScopedState<PickMeUpViewControllerState>) {
    self.getPickMeUpState = getPickMeUpState
  }

  public func getDropoffLocationPickerViewControllerState(appState: AppState) -> ScopedState<DropoffLocationPickerViewControllerState> {
    let pickMeUpScopedState = getPickMeUpState(appState)
    guard case .inScope(let pickMeUpViewControllerState) = pickMeUpScopedState else {
      return .outOfScope
    }
    guard case .selectDropoffLocation(let dropoffLocationPickerViewControllerState) = pickMeUpViewControllerState.state else {
      return .outOfScope
    }
    return .inScope(dropoffLocationPickerViewControllerState)
  }

  public func getMapViewControllerState(appState: AppState) -> ScopedState<MapViewControllerState> {
    let pickMeUpScopedState = getPickMeUpState(appState)
    guard case .inScope(let pickMeUpViewControllerState) = pickMeUpScopedState else {
      return .outOfScope
    }
    return .inScope(pickMeUpViewControllerState.mapViewControllerState)
  }

  public func getRideOptionPickerViewControllerState(appState: AppState) -> ScopedState<RideOptionPickerViewControllerState> {
    let pickMeUpScopedState = getPickMeUpState(appState)
    guard case .inScope(let pickMeUpViewControllerState) = pickMeUpScopedState else {
      return .outOfScope
    }
    guard case .selectRideOption(let rideOptionPickerViewControllerState, _) = pickMeUpViewControllerState.state else {
      return .outOfScope
    }
    return .inScope(rideOptionPickerViewControllerState)
  }
}
