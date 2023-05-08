import Foundation
import ReSwift

extension Reducers {

  static func launchingReducer(action: Action,
                               state: LaunchViewControllerState?) -> LaunchViewControllerState {
    var state = state ?? LaunchViewControllerState()

    switch action {
    case let action as LaunchingActions.FinishedLaunchingAppWithError:
      state.errorsToPresent.insert(action.errorMessage)
    default:
      break
    }

    return state
  }
}
