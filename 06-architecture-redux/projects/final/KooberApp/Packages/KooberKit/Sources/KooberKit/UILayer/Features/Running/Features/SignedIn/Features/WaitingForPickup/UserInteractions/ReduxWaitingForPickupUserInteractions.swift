import Foundation
import ReSwift

public class ReduxWaitingForPickupUserInteractions: WaitingForPickupUserInteractions {

  // MARK: - Properties
  let actionDispatcher: ActionDispatcher

  // MARK: - Methods
  public init(actionDispatcher: ActionDispatcher) {
    self.actionDispatcher = actionDispatcher
  }

  public func startNewRide() {
    let action = SignedInActions.StartNewRideRequest()
    actionDispatcher.dispatch(action)
  }
}
