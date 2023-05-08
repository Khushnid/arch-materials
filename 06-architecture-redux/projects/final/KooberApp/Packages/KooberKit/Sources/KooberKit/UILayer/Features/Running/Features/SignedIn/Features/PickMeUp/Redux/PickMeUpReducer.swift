

import Foundation
import ReSwift

extension Reducers {

  static func pickMeUpReducer(action: Action, state: PickMeUpViewControllerState) -> PickMeUpViewControllerState {
    var state = state

    switch action {
    case _ as PickMeUpActions.GoToDropoffLocationPicker:

      let initialDropoffLocationViewControllerState = DropoffLocationPickerViewControllerState(pickupLocation: state.pickupLocation,
                                                                                               searchResults: [],
                                                                                               currentSearchID: nil,
                                                                                               errorsToPresent: [])
      state.state = .selectDropoffLocation(initialDropoffLocationViewControllerState)
    case _ as DropoffLocationPickerActions.CancelDropoffLocationPicker:
      state.state = .initial
    case let action as DropoffLocationPickerActions.DropoffLocationSelected:
      let waypoints = NewRideWaypoints(pickupLocation: state.pickupLocation, dropoffLocation: action.dropoffLocation)
      state.progress = .waypointsDetermined(waypoints: waypoints)
      state.mapViewControllerState.dropoffLocation = action.dropoffLocation

      let initialRideOptionPickerViewControllerState = RideOptionPickerViewControllerState(segmentedControlState: RideOptionSegmentedControlState(segments: []),
                                                                                           errorsToPresent: [])
      state.state = .selectRideOption(initialRideOptionPickerViewControllerState, confirmingRequest: false)
      state.shouldDisplayWhereTo = false
    case let action as RideOptionPickerActions.RideOptionSelected:
      guard case let .selectRideOption(rideOptionPickeViewControllerState, _) = state.state else {
        break
      }
      state.state = .selectRideOption(rideOptionPickeViewControllerState, confirmingRequest: true)
      if case .waypointsDetermined(let waypoints) = state.progress {
        let rideRequest = NewRideRequest(waypoints: waypoints,
                                         rideOptionID: action.rideOptionID)
        state.progress = .rideRequestReady(rideRequest: rideRequest)
      } else if case .rideRequestReady(let oldRideRequest) = state.progress {
        let rideRequest = NewRideRequest(waypoints: oldRideRequest.waypoints,
                                         rideOptionID: action.rideOptionID)
        state.progress = .rideRequestReady(rideRequest: rideRequest)
      } else {
        fatalError()
      }
    case _ as PickMeUpActions.ConfirmedNewRideRequest:
      guard case .rideRequestReady(let rideRequest) = state.progress else {
        fatalError()
      }
      state.sendingState = .send(rideRequest)
    case _ as PickMeUpActions.NewRideRequestSent:
      state.sendingState = .notSending
      state.state = .final
    case let action as PickMeUpActions.FailedToSendNewRideRequest:
      state.errorsToPresent.insert(action.errorMessage)
    case let action as PickMeUpActions.FinishedPresentingNewRideRequestError:
      state.errorsToPresent.remove(action.errorMessage)
      if state.errorsToPresent.isEmpty {
        state.sendingState = .notSending
      }
    default:
      break
    }

    switch state.state {
    case .selectDropoffLocation(let dropoffLocationPickerViewControllerState):
      state.state = .selectDropoffLocation(Reducers.dropoffLocationPickerReducer(action: action,
                                                                                state: dropoffLocationPickerViewControllerState))
    case let .selectRideOption(rideOptionPickerViewControllerState, confirmingRequest):
      state.state = .selectRideOption(Reducers.rideOptionPickerReducer(action: action, state: rideOptionPickerViewControllerState),
                                      confirmingRequest: confirmingRequest)
    default:
      break
    }

    return state
  }
}
