import Foundation
import ReSwift

extension Reducers {
    
    static func onboardingReducer(action: Action, state: OnboardingState?) -> OnboardingState {
        var state = state ?? .welcoming
        
        switch action {
        case _ as WelcomeActions.GoToSignUp:
            state = OnboardingLogic.goToSignUp()
        case _ as WelcomeActions.GoToSignIn:
            state = OnboardingLogic.goToSignIn()
        case _ as OnboardingActions.NavigatedBackToWelcome:
            state = OnboardingLogic.navigatedBackToWelcome()
        default:
            break
        }
        
        switch state {
        case .signingUp(let signUpViewControllerState):
            state = .signingUp(Reducers.signUpReducer(action: action,
                                                      state: signUpViewControllerState))
        case .signingIn(let signInViewControllerState):
            state = .signingIn(Reducers.signInReducer(action: action,
                                                      state: signInViewControllerState))
            break
        case .welcoming:
            break
        }
        
        return state
    }
}
