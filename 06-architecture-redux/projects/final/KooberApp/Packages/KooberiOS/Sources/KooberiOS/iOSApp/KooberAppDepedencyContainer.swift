import UIKit
import KooberKit
import ReSwift
import Combine

public class KooberAppDependencyContainer {
    
    // MARK: - Properties
    let userSessionDataStore: UserSessionDataStore
    let stateStore: Store<AppState> = {
        return Store(reducer: Reducers.appReducer,
                     state: .launching(LaunchViewControllerState()),
                     middleware: []) // printActionMiddleware
    }()
    let entryPointGetters = EntryPointGetters()
    let appRunningGetters: AppRunningGetters
    let userSessionStatePersister: UserSessionStatePersister
    
    // MARK: - Methods
    public init() {
        func makeUserSessionDataStore() -> UserSessionDataStore {
            let userSessionCoder: UserSessionCoding = UserSessionPropertyListCoder()
            return KeychainUserSessionDataStore(userSessionCoder: userSessionCoder)
        }
        self.userSessionDataStore = makeUserSessionDataStore()
        self.appRunningGetters = AppRunningGetters(getAppRunningState: entryPointGetters.getAppRunningState)
        self.userSessionStatePersister = ReduxUserSessionStatePersister(reduxStore: stateStore)
    }
    
    // Main
    public func makeMainViewController() -> MainViewController {
        let statePublisher = makeAppStatePublisher()
        let launchViewController = makeLaunchViewController()
        let onboardingViewControllerFactory = {
            // `self` is the app dependency container which lives as long
            //  as the app's process. `self` does not hold on to the
            //  view controller created in this closure.
            //  Therefore, it's ok to capture strong `self` here.
            return self.makeOnboardingViewController()
        }
        let signedInViewControllerFactory = { (userSession: UserSession) in
            // `self` is the app dependency container which lives as long
            //  as the app's process. `self` does not hold on to the
            //  view controller created in this closure.
            //  Therefore, it's ok to capture strong `self` here.
            return self.makeSignedInViewController(session: userSession)
        }
        return MainViewController(statePublisher: statePublisher,
                                  launchViewController: launchViewController,
                                  onboardingViewControllerFactory: onboardingViewControllerFactory,
                                  signedInViewControllerFactory: signedInViewControllerFactory)
    }
    
    public func makeAppStatePublisher() -> AnyPublisher<AppState, Never> {
        return stateStore.publisher()
    }
    
    // Launching
    public func makeLaunchViewController() -> LaunchViewController {
        let userInteractions = makeLaunchingUserInteractions()
        let statePublisher = makeLaunchViewControllerStatePublisher()
        return LaunchViewController(statePublisher: statePublisher,
                                    userInteractions: userInteractions)
    }
    
    public func makeLaunchingUserInteractions() -> LaunchingUserInteractions {
        let actionDispatcher: ActionDispatcher = stateStore
        return ReduxLaunchingUserInteractions(actionDispatcher: actionDispatcher,
                                              userSessionDataStore: userSessionDataStore,
                                              userSessionStatePersister: userSessionStatePersister)
    }
    
    public func makeLaunchViewControllerStatePublisher() -> AnyPublisher<LaunchViewControllerState, Never> {
        let statePublisher =
        stateStore
            .publisher { subscription in
                subscription.select(self.entryPointGetters.getLaunchViewControllerState)
            }
        return statePublisher
    }
    
    // Onboarding (signed-out)
    public func makeOnboardingViewController() -> OnboardingViewController {
        let dependencyContainer = KooberOnboardingDependencyContainer(appContainer: self)
        return dependencyContainer.makeOnboardingViewController()
    }
    
    // Signed-in
    public func makeSignedInViewController(session: UserSession) -> SignedInViewController {
        let dependencyContainer = makeSignedInContainer(session: session)
        return dependencyContainer.makeSignedInViewController()
    }
    
    public func makeSignedInContainer(session: UserSession) -> KooberSignedInDependencyContainer  {
        return KooberSignedInDependencyContainer(userSession: session, appContainer: self)
    }
}
