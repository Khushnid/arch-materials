import Foundation

public struct OnboardingGetters {

  // MARK: - Properties
  public let getOnboardingState: (AppState) -> ScopedState<OnboardingState>

  // MARK: - Methods
  public init(getOnboardingState: @escaping (AppState) -> ScopedState<OnboardingState>) {
    self.getOnboardingState = getOnboardingState
  }

  public func getSignInViewControllerState(appState: AppState) -> ScopedState<SignInViewControllerState> {
    let onboardingScopedState = getOnboardingState(appState)
    guard case .inScope(let onboardingState) = onboardingScopedState else {
      return .outOfScope
    }
    guard case .signingIn(let signInViewControllerState) = onboardingState else {
      return .outOfScope
    }
    return .inScope(signInViewControllerState)
  }

  public func getSignUpViewControllerState(appState: AppState) -> ScopedState<SignUpViewControllerState> {
    let onboardingScopedState = getOnboardingState(appState)
    guard case .inScope(let onboardingState) = onboardingScopedState else {
      return .outOfScope
    }
    guard case .signingUp(let signUpViewControllerState) = onboardingState else {
      return .outOfScope
    }
    return .inScope(signUpViewControllerState)
  }
}
