import Foundation

public struct AppRunningGetters {

  // MARK: - Properties
  public let getAppRunningState: (AppState) -> ScopedState<AppRunningState>

  // MARK: - Methods
  public init(getAppRunningState: @escaping (AppState) -> ScopedState<AppRunningState>) {
    self.getAppRunningState = getAppRunningState
  }

  public func getOnboardingState(appState: AppState) -> ScopedState<OnboardingState> {
    let runningScopedState = getAppRunningState(appState)
    guard case .inScope(let runningState) = runningScopedState else {
      return .outOfScope
    }
    guard case .onboarding(let onboardingState) = runningState else {
      return .outOfScope
    }
    return .inScope(onboardingState)
  }

  public func getSignedInViewControllerState(appState: AppState) -> ScopedState<SignedInViewControllerState> {
    let runningScopedState = getAppRunningState(appState)
    guard case .inScope(let runningState) = runningScopedState else {
      return .outOfScope
    }
    guard case .signedIn(let signedInViewControllerState, _) = runningState else {
      return .outOfScope
    }
    return .inScope(signedInViewControllerState)
  }

  public func getAuthenticationState(appState: AppState) -> AuthenticationState? {
    let runningScopedState = getAppRunningState(appState)
    guard case .inScope(let runningState) = runningScopedState else {
      return nil
    }
    guard case .signedIn(_, let userSession) = runningState else {
      return .notSignedIn
    }
    return .signedIn(userSession)
  }
}
