import UIKit
import KooberUIKit
import PromiseKit
import KooberKit
import Combine

public class MainViewController: NiblessViewController {
    
    // MARK: - Properties
    // Child View Controllers
    let launchViewController: LaunchViewController
    var signedInViewController: SignedInViewController?
    var onboardingViewController: OnboardingViewController?
    
    // State
    let statePublisher: AnyPublisher<AppState, Never>
    var subscriptions = Set<AnyCancellable>()
    
    // Factories
    let makeOnboardingViewController: () -> OnboardingViewController
    let makeSignedInViewController: (UserSession) -> SignedInViewController
    
    // MARK: - Methods
    public init(statePublisher: AnyPublisher<AppState, Never>,
                launchViewController: LaunchViewController,
                onboardingViewControllerFactory: @escaping () -> OnboardingViewController,
                signedInViewControllerFactory: @escaping (UserSession) -> SignedInViewController) {
        self.statePublisher = statePublisher
        self.launchViewController = launchViewController
        self.makeOnboardingViewController = onboardingViewControllerFactory
        self.makeSignedInViewController = signedInViewControllerFactory
        super.init()
    }
    
    func observeState() {
        statePublisher
            .receive(on: DispatchQueue.main)
            .map(MainViewControllerState.mainViewControllerState(fromAppState:))
            .removeDuplicates()
            .sink { [weak self] viewControllerState in
                self?.present(viewControllerState)
            }
            .store(in: &subscriptions)
    }
    
    func present(_ state: MainViewControllerState) {
        switch state {
        case .launching:
            presentLaunching()
        case .onboarding:
            if onboardingViewController?.presentingViewController == nil {
                if presentedViewController.exists {
                    // Dismiss profile modal when signing out.
                    dismiss(animated: true) { [weak self] in
                        self?.presentOnboarding()
                    }
                } else {
                    presentOnboarding()
                }
            }
        case .signedIn(let userSession):
            presentSignedIn(userSession: userSession)
        }
    }
    
    public func presentLaunching() {
        addFullScreen(childViewController: launchViewController)
    }
    
    public func presentOnboarding() {
        let onboardingViewController = makeOnboardingViewController()
        onboardingViewController.modalPresentationStyle = .fullScreen
        present(onboardingViewController, animated: true) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.remove(childViewController: self.launchViewController)
            if let signedInViewController = self.signedInViewController {
                self.remove(childViewController: signedInViewController)
                self.signedInViewController = nil
            }
        }
        self.onboardingViewController = onboardingViewController
    }
    
    public func presentSignedIn(userSession: UserSession) {
        remove(childViewController: launchViewController)
        
        let signedInViewControllerToPresent: SignedInViewController
        if let vc = self.signedInViewController {
            signedInViewControllerToPresent = vc
        } else {
            signedInViewControllerToPresent = makeSignedInViewController(userSession)
            self.signedInViewController = signedInViewControllerToPresent
        }
        
        addFullScreen(childViewController: signedInViewControllerToPresent)
        
        if onboardingViewController?.presentingViewController != nil {
            onboardingViewController = nil
            dismiss(animated: true)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        observeState()
    }
}
