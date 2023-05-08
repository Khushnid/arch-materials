import Foundation
import ReSwift

extension Reducers {
    static func rideOptionPickerReducer(action: Action, state: RideOptionPickerViewControllerState?) -> RideOptionPickerViewControllerState {
        var state = state ?? RideOptionPickerViewControllerState(segmentedControlState: RideOptionSegmentedControlState(segments: []),
                                                                 errorsToPresent: [])
        switch action {
        case let action as RideOptionPickerActions.RideOptionsLoaded:
            state.segmentedControlState = action.rideOptions
        case let action as RideOptionPickerActions.RideOptionSelected:
            var segments = state.segmentedControlState.segments
            for (index, segment) in state.segmentedControlState.segments.enumerated() {
                segments[index].isSelected = (segment.id == action.rideOptionID)
            }
            state.segmentedControlState.segments = segments
        case let action as RideOptionPickerActions.FailedToLoadRideOptions:
            state.errorsToPresent.insert(action.errorMessage)
        case let action as RideOptionPickerActions.FinishedPresentingError:
            state.errorsToPresent.remove(action.errorMessage)
        default:
            break
        }
        
        return state
    }
}
