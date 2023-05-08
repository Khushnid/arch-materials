

import Foundation
import ReSwift

extension Reducers {

  public static func appReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? .launching(LaunchViewControllerState())

    switch action {
    case let action as LaunchingActions.FinishedLaunchingApp:
      let authenticatedState = action.authenticationState
      state = AppLogic.appState(for: authenticatedState)
    case let action as LaunchingActions.FinishedPresentingLaunchError:
      guard case .launching(var launchingViewControllerState) = state else {
        break
      }
      launchingViewControllerState.errorsToPresent.remove(action.errorMessage)
      if launchingViewControllerState.errorsToPresent.count == 0 {
        state = .running(.onboarding(.welcoming))
      } else {
        state = .launching(launchingViewControllerState)
      }
    default:
      break
    }

    switch state {
    case .launching(let launchViewControllerState):
      state = .launching(Reducers.launchingReducer(action: action,
                                                   state: launchViewControllerState))
    case .running(let runningState):
      state = .running(Reducers.appRunningReducer(action: action,
                                                  state: runningState))
    }

    return state
  }
}
