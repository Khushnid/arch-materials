import Foundation

public enum AppRunningState: Equatable {
  
  case onboarding(OnboardingState)
  case signedIn(SignedInViewControllerState, UserSession)
}
