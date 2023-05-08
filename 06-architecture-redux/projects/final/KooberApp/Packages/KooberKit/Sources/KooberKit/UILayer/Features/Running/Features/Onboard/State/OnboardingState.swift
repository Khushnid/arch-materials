import Foundation

public enum OnboardingState: Equatable {

  case welcoming
  case signingIn(SignInViewControllerState)
  case signingUp(SignUpViewControllerState)

  public static func sameCase(lhs: OnboardingState, rhs: OnboardingState) -> Bool {
    switch (lhs, rhs) {
    case (.welcoming, .welcoming):
      return true
    case (.signingIn, .signingIn):
      return true
    case (.signingUp, .signingUp):
      return true
    case (.welcoming, _),
         (.signingIn, _),
         (.signingUp, _):
      return false
    }
  }
}
