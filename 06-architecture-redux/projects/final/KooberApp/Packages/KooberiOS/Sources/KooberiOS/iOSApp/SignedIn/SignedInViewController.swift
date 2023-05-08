import UIKit
import KooberUIKit
import KooberKit
import Combine

public class SignedInViewController: NiblessViewController {
    
    // MARK: - Properties
    // Child View Controllers
    let profileViewController: ProfileViewController
    var currentChildViewController: UIViewController?
    
    // State
    let statePublisher: AnyPublisher<SignedInViewControllerState, Never>
    let userSession: UserSession
    var subscriptions = Set<AnyCancellable>()
    
    // User Interactions
    let userInteractions: SignedInUserInteractions
    
    // Factories
    let viewControllerFactory: SignedInViewControllerFactory
    
    // MARK: - Methods
    init(statePublisher: AnyPublisher<SignedInViewControllerState, Never>,
         userInteractions: SignedInUserInteractions,
         userSession: UserSession,
         profileViewController: ProfileViewController,
         viewControllerFactory: SignedInViewControllerFactory) {
        self.statePublisher = statePublisher
        self.userInteractions = userInteractions
        self.userSession = userSession
        self.profileViewController = profileViewController
        self.viewControllerFactory = viewControllerFactory
        super.init()
    }
    
    public override func loadView() {
        view = SignedInRootView(userInteractions: userInteractions)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        observeState()
    }
    
    func observeState() {
        statePublisher
            .receive(on: DispatchQueue.main)
            .map { $0.viewingProfile }
            .removeDuplicates()
            .sink { [weak self] viewingProfile in
                self?.update(showingProfileScreen: viewingProfile)
            }
            .store(in: &subscriptions)
        
        statePublisher
            .receive(on: DispatchQueue.main)
            .map { $0.newRideState }
            .removeDuplicates(by: NewRideState.sameCase)
            .sink { [weak self] newRideState in
                self?.present(newRideState)
            }
            .store(in: &subscriptions)
    }
    
    func update(showingProfileScreen: Bool) {
        if showingProfileScreen {
            if presentedViewController.isEmpty {
                present(profileViewController, animated: true)
            }
        } else {
            if profileViewController.view.window != nil {
                dismiss(animated: true)
            }
        }
    }
    
    func present(_ state: NewRideState) {
        switch state {
        case .gettingUsersLocation:
            let viewController = viewControllerFactory.makeGettingUsersLocationViewController()
            transition(to: viewController)
        case .requestingNewRide(let pickupLocation, _):
            let viewController = viewControllerFactory.makePickMeUpViewController(pickupLocation: pickupLocation)
            transition(to: viewController)
        case .waitingForPickup:
            let viewController = viewControllerFactory.makeWaitingForPickupViewController()
            transition(to: viewController)
        }
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        currentChildViewController?.view.frame = view.bounds
    }
    
    func transition(to viewController: UIViewController) {
        remove(childViewController: currentChildViewController)
        addFullScreen(childViewController: viewController)
        currentChildViewController = viewController
    }
}

protocol SignedInViewControllerFactory {
    
    func makeGettingUsersLocationViewController() -> GettingUsersLocationViewController
    func makePickMeUpViewController(pickupLocation: Location) -> PickMeUpViewController
    func makeWaitingForPickupViewController() -> WaitingForPickupViewController
}
