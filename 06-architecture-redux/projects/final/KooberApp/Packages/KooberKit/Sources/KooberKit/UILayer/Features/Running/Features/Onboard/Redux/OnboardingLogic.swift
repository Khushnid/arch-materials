import Foundation

struct OnboardingLogic {
    
    static func goToSignIn() -> OnboardingState {
        return .signingIn(SignInViewControllerState())
    }
    
    static func goToSignUp() -> OnboardingState {
        return .signingUp(SignUpViewControllerState())
    }
    
    static func navigatedBackToWelcome() -> OnboardingState {
        return .welcoming
    }
}
