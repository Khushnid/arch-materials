import Foundation

public struct SignUpViewControllerState: Equatable {

  // MARK: - Properties
  public internal(set) var errorsToPresent: Set<ErrorMessage> = []
}
