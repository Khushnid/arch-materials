

import Foundation
import ReSwift

extension Reducers {

  static func newRideReducer(action: Action, state: NewRideState?) -> NewRideState {
    var state = state ?? .gettingUsersLocation(Reducers.gettingUsersLocationReducer(action: action,
                                                                                    state: nil))

    switch action {
    case let action as SignedInActions.PickUpLocationDetermined:
      let initialMapViewControllerState =
        MapViewControllerState(pickupLocation: action.pickupLocation,
                               dropoffLocation: nil)
      let initialPickMeUpViewControllerState =
        PickMeUpViewControllerState(pickupLocation: action.pickupLocation,
                                      state: .initial,
                                      sendingState: .notSending,
                                      progress: .initial(pickupLocation: action.pickupLocation),
                                      mapViewControllerState: initialMapViewControllerState,
                                      shouldDisplayWhereTo: true,
                                      errorsToPresent: [])
      state = .requestingNewRide(pickupLocation: action.pickupLocation, initialPickMeUpViewControllerState)
    case _ as SignedInActions.FinishedRequestingNewRide:
      state = .waitingForPickup
    case _ as SignedInActions.StartNewRideRequest:
      state = .gettingUsersLocation(Reducers.gettingUsersLocationReducer(action: action,
                                                                         state: nil))
    default:
      break
    }

    switch state {
    case let .gettingUsersLocation(gettingUsersLocationViewControllerState):
      state = .gettingUsersLocation(Reducers.gettingUsersLocationReducer(action: action,
                                                                         state: gettingUsersLocationViewControllerState))
    case let .requestingNewRide(pickupLocation, pickMeUpViewControllerState):
      let newViewControllerState = Reducers.pickMeUpReducer(action: action, state: pickMeUpViewControllerState)
      state = .requestingNewRide(pickupLocation: pickupLocation, newViewControllerState)
    default:
      break
    }

    return state
  }
}
