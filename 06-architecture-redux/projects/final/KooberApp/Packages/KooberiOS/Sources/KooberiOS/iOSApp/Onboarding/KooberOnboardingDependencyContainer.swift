import UIKit
import KooberKit
import Combine
import ReSwift

public class KooberOnboardingDependencyContainer {
    
    // MARK: - Properties
    
    // From parent container
    let appRunningGetters: AppRunningGetters
    let actionDispatcher: ActionDispatcher
    let stateStore: Store<AppState>
    
    let onboardingGetters: OnboardingGetters
    
    // MARK: - Methods
    init(appContainer: KooberAppDependencyContainer) {
        self.appRunningGetters = appContainer.appRunningGetters
        self.actionDispatcher = appContainer.stateStore
        self.stateStore = appContainer.stateStore
        self.onboardingGetters = OnboardingGetters(getOnboardingState: appRunningGetters.getOnboardingState)
    }
    
    // Onboarding
    public func makeOnboardingViewController() -> OnboardingViewController {
        let statePublisher = makeOnboardingStatePublisher()
        let userInteractions = makeOnboardingUserInteractions()
        let welcomeViewController = makeWelcomeViewController()
        let signInViewController = makeSignInViewController()
        let signUpViewController = makeSignUpViewController()
        return OnboardingViewController(statePublisher: statePublisher,
                                        userInteractions: userInteractions,
                                        welcomeViewController: welcomeViewController,
                                        signInViewController: signInViewController,
                                        signUpViewController: signUpViewController)
    }
    
    public func makeOnboardingStatePublisher() -> AnyPublisher<OnboardingState, Never> {
        let statePublisher =
        stateStore
            .publisher { subscription in
                subscription.select(self.appRunningGetters.getOnboardingState)
            }
        return statePublisher
    }
    
    public func makeOnboardingUserInteractions() -> OnboardingUserInteractions {
        return ReduxOnboardingUserInteractions(actionDispatcher: actionDispatcher)
    }
    
    // Welcome
    public func makeWelcomeViewController() -> WelcomeViewController {
        let userInteractions = makeWelcomeUserInteractions()
        return WelcomeViewController(userInteractions: userInteractions)
    }
    
    public func makeWelcomeUserInteractions() -> WelcomeUserInteractions {
        return ReduxWelcomeUserInteractions(actionDispatcher: actionDispatcher)
    }
    
    // Sign In
    public func makeSignInViewController() -> SignInViewController {
        let statePublisher = makeSignInViewControllerStatePublisher()
        let userInteractions = makeSignInUserInteractions()
        return SignInViewController(state: statePublisher,
                                    userInteractions: userInteractions)
    }
    
    public func makeSignInViewControllerStatePublisher() -> AnyPublisher<SignInViewControllerState, Never> {
        let statePublisher =
        stateStore
            .publisher { subscription in
                subscription.select(self.onboardingGetters.getSignInViewControllerState)
            }
        return statePublisher
    }
    
    public func makeSignInUserInteractions() -> SignInUserInteractions {
        let authRemoteAPI = makeAuthRemoteAPI()
        return ReduxSignInUserInteractions(actionDispatcher: actionDispatcher,
                                           remoteAPI: authRemoteAPI)
    }
    
    // Sign Up
    public func makeSignUpViewController() -> SignUpViewController {
        let statePublisher = makeSignUpViewControllerStatePublisher()
        let userInteractions = makeSignUpUserInteractions()
        return SignUpViewController(statePublisher: statePublisher,
                                    userInteractions: userInteractions)
    }
    
    public func makeSignUpViewControllerStatePublisher() -> AnyPublisher<SignUpViewControllerState, Never> {
        let statePublisher =
        stateStore
            .publisher { subscription in
                subscription.select(self.onboardingGetters.getSignUpViewControllerState)
            }
        return statePublisher
    }
    
    public func makeSignUpUserInteractions() -> SignUpUserInteractions {
        let authRemoteAPI = makeAuthRemoteAPI()
        return ReduxSignUpUserInteractions(actionDispatcher: actionDispatcher,
                                           remoteAPI: authRemoteAPI)
    }
    
    // Shared
    public func makeAuthRemoteAPI() -> AuthRemoteAPI {
        return FakeAuthRemoteAPI()
    }
}
