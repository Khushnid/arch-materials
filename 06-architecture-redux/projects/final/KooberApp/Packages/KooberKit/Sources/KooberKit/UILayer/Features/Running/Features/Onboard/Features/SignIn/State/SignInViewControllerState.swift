import Foundation

public struct SignInViewControllerState: Equatable {

  // MARK: - Properties
  public internal(set) var viewState = SignInViewState()
  public internal(set) var errorsToPresent: Set<ErrorMessage> = []

  // MARK: - Methods
  public init() {}
}

public struct SignInViewState: Equatable {

  // MARK: - Properties
  public internal(set) var emailInputEnabled = true
  public internal(set) var passwordInputEnabled = true
  public internal(set) var signInButtonEnabled = true
  public internal(set) var signInActivityIndicatorAnimating = false

  // MARK: - Methods
  public init() {}
}
