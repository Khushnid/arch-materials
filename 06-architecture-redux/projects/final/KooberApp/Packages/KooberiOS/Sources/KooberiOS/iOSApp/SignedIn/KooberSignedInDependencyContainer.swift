import UIKit
import KooberUIKit
import KooberKit
import Combine
import ReSwift

public class KooberSignedInDependencyContainer {
    
    // MARK: - Properties
    
    // From parent container
    let appRunningGetters: AppRunningGetters
    let actionDispatcher: ActionDispatcher
    let stateStore: Store<AppState>
    
    let userSession: UserSession
    
    let imageCache: ImageCache = InBundleImageCache()
    let locator: Locator = FakeLocator()
    let rideOptionDataStore: RideOptionDataStore = RideOptionDataStoreDiskUserPrefs()
    let newRideRemoteAPI: NewRideRemoteAPI = FakeNewRideRemoteAPI()
    let signedInGetters: SignedInGetters
    
    // MARK: - Methods
    public init(userSession: UserSession, appContainer: KooberAppDependencyContainer) {
        self.appRunningGetters = appContainer.appRunningGetters
        self.actionDispatcher = appContainer.stateStore
        self.stateStore = appContainer.stateStore
        
        self.userSession = userSession
        self.signedInGetters = SignedInGetters(getSignedInState: appRunningGetters.getSignedInViewControllerState)
    }
    
    // Signed In
    public func makeSignedInViewController() -> SignedInViewController {
        let statePublisher = makeSignedInViewControllerStatePublisher()
        let userInteractions = makeSignedInUserInteractions()
        let profileViewController = makeProfileViewController()
        return SignedInViewController(statePublisher: statePublisher,
                                      userInteractions: userInteractions,
                                      userSession: userSession,
                                      profileViewController: profileViewController,
                                      viewControllerFactory: self)
    }
    
    public func makeSignedInViewControllerStatePublisher() -> AnyPublisher<SignedInViewControllerState, Never> {
        let statePublisher =
        stateStore
            .publisher { subscription in
                subscription.select(self.appRunningGetters.getSignedInViewControllerState)
            }
        return statePublisher
    }
    
    public func makeSignedInUserInteractions() -> SignedInUserInteractions {
        return ReduxSignedInUserInteractions(actionDispatcher: actionDispatcher)
    }
    
    // Getting Users Location
    public func makeGettingUsersLocationViewController() -> GettingUsersLocationViewController {
        let statePublisher = makeGettingUsersLocationViewControllerStatePublisher()
        let userInteractions = makeGettingUsersLocationUserInteractions()
        return GettingUsersLocationViewController(statePublisher: statePublisher,
                                                  userInteractions: userInteractions)
    }
    
    public func makeGettingUsersLocationViewControllerStatePublisher() -> AnyPublisher<GettingUsersLocationViewControllerState, Never> {
        let statePublisher =
        stateStore
            .publisher { subscription in
                subscription.select(self.signedInGetters.getGettingUsersLocationViewControllerState)
            }
        return statePublisher
    }
    
    public func makeGettingUsersLocationUserInteractions() -> GettingUsersLocationUserInteractions {
        return ReduxGettingUsersLocationUserInteractions(actionDispatcher: actionDispatcher,
                                                         locator: locator)
    }
    
    // Pick Me Up
    public func makePickMeUpViewController(pickupLocation: Location) -> PickMeUpViewController {
        let pickMeUpDependencyContainer = KooberPickMeUpDependencyContainer(pickupLocation: pickupLocation,
                                                                            signedInDependencyContainer: self)
        return pickMeUpDependencyContainer.makePickMeUpViewController()
    }
    
    // Waiting for Pickup
    public func makeWaitingForPickupViewController() -> WaitingForPickupViewController {
        let userInteractions = makeWaitingForPickupUserInteractions()
        return WaitingForPickupViewController(userInteractions: userInteractions)
    }
    
    public func makeWaitingForPickupUserInteractions() -> WaitingForPickupUserInteractions {
        return ReduxWaitingForPickupUserInteractions(actionDispatcher: actionDispatcher)
    }
    
    // View Profile
    public func makeProfileViewController() -> ProfileViewController {
        let contentViewController = makeProfileContentViewController()
        return ProfileViewController(contentViewController: contentViewController)
    }
    
    private func makeProfileContentViewController() -> ProfileContentViewController {
        let statePublisher = makeProfileViewControllerStatePublisher()
        let userInteractions = makeProfileUserInteractions()
        return ProfileContentViewController(statePublisher: statePublisher,
                                            userInteractions: userInteractions)
    }
    
    public func makeProfileViewControllerStatePublisher() -> AnyPublisher<ProfileViewControllerState, Never> {
        let statePublisher =
        stateStore
            .publisher { subscription in
                subscription.select(self.signedInGetters.getProfileViewControllerState)
            }
        return statePublisher
    }
    
    public func makeProfileUserInteractions() -> ProfileUserInteractions {
        return ReduxProfileUserInteractions(actionDispatcher: actionDispatcher,
                                            userSession: userSession)
    }
}

extension KooberSignedInDependencyContainer: SignedInViewControllerFactory {}
