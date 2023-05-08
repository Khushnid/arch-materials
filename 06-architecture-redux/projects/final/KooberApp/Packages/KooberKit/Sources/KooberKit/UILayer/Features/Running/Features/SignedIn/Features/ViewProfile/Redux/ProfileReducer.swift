import Foundation
import ReSwift

extension Reducers {

  static func profileReducer(action: Action, state: ProfileViewControllerState) -> ProfileViewControllerState {
    var state = state

    switch action {
    case let action as ProfileActions.SignOutFailed:
      state.errorsToPresent.insert(action.errorMessage)
    case let action as ProfileActions.FinishedPresentingError:
      state.errorsToPresent.remove(action.errorMessage)
    default:
      break
    }

    return state
  }
}
