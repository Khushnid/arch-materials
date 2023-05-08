import Foundation

public class ReduxLaunchingUserInteractions: LaunchingUserInteractions {

  // MARK: - Properties
  let actionDispatcher: ActionDispatcher
  let userSessionDataStore: UserSessionDataStore
  let userSessionStatePersister: UserSessionStatePersister

  // MARK: - Methods
  public init(actionDispatcher: ActionDispatcher,
              userSessionDataStore: UserSessionDataStore,
              userSessionStatePersister: UserSessionStatePersister) {
    self.actionDispatcher = actionDispatcher
    self.userSessionDataStore = userSessionDataStore
    self.userSessionStatePersister = userSessionStatePersister
  }
  
  public func launchApp() {
    loadUserSession()
  }

  public func finishedPresenting(errorMessage: ErrorMessage) {
    let action = LaunchingActions.FinishedPresentingLaunchError(errorMessage: errorMessage)
    actionDispatcher.dispatch(action)
  }

  private func loadUserSession() {
    userSessionDataStore.readUserSession()
      .done(finishedLaunchingApp(userSession:))
      .catch { error in
        let errorMessage =
          ErrorMessage(title: "Sign In Error",
                       message: """
                         Sorry, we couldn't determine \
                         if you are already signed in.
                         Please sign in or sign up.
                        """)
        self.present(errorMessage: errorMessage)
    }
  }

  private func finishedLaunchingApp(userSession: UserSession?) {
    let authenticationState = AuthenticationState(userSession: userSession)
    let action = LaunchingActions.FinishedLaunchingApp(authenticationState: authenticationState)
    actionDispatcher.dispatch(action)
    userSessionStatePersister.startPersistingStateChanges(to: userSessionDataStore)
  }

  private func present(errorMessage: ErrorMessage) {
    let action = LaunchingActions.FinishedLaunchingAppWithError(errorMessage: errorMessage)
    actionDispatcher.dispatch(action)
  }
}
