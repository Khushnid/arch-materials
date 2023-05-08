

import Foundation
import ReSwift

struct LaunchingActions {

  struct FinishedLaunchingApp: Action {

    let authenticationState: AuthenticationState
  }

  struct FinishedLaunchingAppWithError: Action {

    let errorMessage: ErrorMessage
  }

  struct FinishedPresentingLaunchError: Action {

    let errorMessage: ErrorMessage
  }
}
