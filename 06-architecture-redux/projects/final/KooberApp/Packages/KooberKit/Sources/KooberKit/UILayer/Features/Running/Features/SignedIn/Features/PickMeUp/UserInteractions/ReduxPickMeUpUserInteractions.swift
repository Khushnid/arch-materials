import Foundation
import ReSwift
import PromiseKit

public class ReduxPickMeUpUserInteractions: PickMeUpUserInteractions {

  // MARK: - Properties
  let actionDispatcher: ActionDispatcher
  let newRideRepository: NewRideRepository

  // MARK: - Methods
  public init(actionDispatcher: ActionDispatcher,
              newRideRepository: NewRideRepository) {
    self.actionDispatcher = actionDispatcher
    self.newRideRepository = newRideRepository
  }

  public func goToDropoffLocationPicker() {
    let action = PickMeUpActions.GoToDropoffLocationPicker()
    actionDispatcher.dispatch(action)
  }

  public func confirmNewRideRequest() {
    let action = PickMeUpActions.ConfirmedNewRideRequest()
    actionDispatcher.dispatch(action)
  }

  public func send(_ newRideRequest: NewRideRequest) {
    newRideRepository.request(newRide: newRideRequest)
      .done {
        let action = PickMeUpActions.NewRideRequestSent()
        self.actionDispatcher.dispatch(action)
      }.catch { error in
        let errorMessage = ErrorMessage(title: "Ride Request Error",
                                        message: "There was an error trying to confirm your ride request.\nPlease try again.")
        let action = PickMeUpActions.FailedToSendNewRideRequest(errorMessage: errorMessage)
        self.actionDispatcher.dispatch(action)
    }
  }

  public func finishedRequestingNewRide() {
    let action = SignedInActions.FinishedRequestingNewRide()
    actionDispatcher.dispatch(action)
  }

  public func finishedPresentingNewRequestError(_ errorMessage: ErrorMessage) {
    let action = PickMeUpActions.FinishedPresentingNewRideRequestError(errorMessage: errorMessage)
    actionDispatcher.dispatch(action)
  }
}
