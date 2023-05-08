import Foundation
import ReSwift

struct SignUpActions {

  struct SignUpFailed: Action {

    // MARK: - Properties
    let errorMessage: ErrorMessage
  }

  struct FinishedPresentingError: Action {

    // MARK: - Properties
    let errorMessage: ErrorMessage
  }
}
