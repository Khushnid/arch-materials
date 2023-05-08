import UIKit
import KooberUIKit
import PromiseKit
import KooberKit
import Combine

public class OnboardingViewController: NiblessNavigationController {
    
    // MARK: - Properties
    // State
    let statePublisher: AnyPublisher<OnboardingState, Never>
    var stateSubscription: AnyCancellable?
    var welcomePushed = false
    
    // User Interactions
    let userInteractions: OnboardingUserInteractions
    
    // Child View Controllers
    let welcomeViewController: WelcomeViewController
    let signInViewController: SignInViewController
    let signUpViewController: SignUpViewController
    
    // MARK: - Methods
    init(statePublisher: AnyPublisher<OnboardingState, Never>,
         userInteractions: OnboardingUserInteractions,
         welcomeViewController: WelcomeViewController,
         signInViewController: SignInViewController,
         signUpViewController: SignUpViewController) {
        self.statePublisher = statePublisher
        self.userInteractions = userInteractions
        self.welcomeViewController = welcomeViewController
        self.signInViewController = signInViewController
        self.signUpViewController = signUpViewController
        super.init()
        self.delegate = self
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        observeState()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopObservingState()
    }
    
    func observeState() {
        stateSubscription =
        statePublisher
            .receive(on: DispatchQueue.main)
            .removeDuplicates(by: OnboardingState.sameCase)
            .sink { [weak self] onboardingState in
                self?.present(onboardingState)
            }
    }
    
    func stopObservingState() {
        stateSubscription?.cancel()
    }
    
    func present(_ onboardingState: OnboardingState) {
        switch onboardingState {
        case .welcoming:
            presentWelcome()
        case .signingIn:
            presentSignIn()
        case .signingUp:
            presentSignUp()
        }
    }
    
    func presentWelcome() {
        if shouldSkipWelcomePresentation() {
            return
        }
        pushViewController(welcomeViewController, animated: false)
        welcomePushed = true
    }
    
    func shouldSkipWelcomePresentation() -> Bool {
        if let _ = topViewController as? WelcomeViewController {
            return true
        } else {
            return false
        }
    }
    
    func presentSignIn() {
        pushViewController(signInViewController, animated: true)
    }
    
    func presentSignUp() {
        pushViewController(signUpViewController, animated: true)
    }
    
    func hideOrShowNavigationBar(navigationWillShow viewControllerToBeShown: UIViewController, animated: Bool) {
        if viewControllerToBeShown is WelcomeViewController {
            hideNavigationBar(animated: animated)
        } else {
            showNavigationBar(animated: animated)
        }
    }
}

// MARK: - Navigation Bar Presentation
extension OnboardingViewController {
    
    func hideNavigationBar(animated: Bool) {
        if animated {
            transitionCoordinator?.animate(alongsideTransition: { context in
                self.setNavigationBarHidden(true, animated: animated)
            })
        } else {
            setNavigationBarHidden(true, animated: false)
        }
    }
    
    func showNavigationBar(animated: Bool) {
        if self.isNavigationBarHidden {
            self.setNavigationBarHidden(false, animated: animated)
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension OnboardingViewController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController,
                                     willShow viewController: UIViewController,
                                     animated: Bool) {
        hideOrShowNavigationBar(navigationWillShow: viewController, animated: animated)
    }
    
    public func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        guard welcomePushed else {
            return
        }
        if viewController is WelcomeViewController {
            userInteractions.navigatedBackToWelcome()
        }
    }
}
