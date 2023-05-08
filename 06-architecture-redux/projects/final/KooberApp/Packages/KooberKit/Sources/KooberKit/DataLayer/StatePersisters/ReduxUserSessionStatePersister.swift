import Foundation
import ReSwift
import Combine

public class ReduxUserSessionStatePersister: UserSessionStatePersister {

  // MARK: - Properties
  let authenticationStatePublisher: AnyPublisher<AuthenticationState?, Never>
  var subscriptions = Set<AnyCancellable>()

  // MARK: - Methods
  public init(reduxStore: Store<AppState>) {
    let runningGetters = AppRunningGetters(getAppRunningState: EntryPointGetters().getAppRunningState)
    self.authenticationStatePublisher =
      reduxStore.publisher { subscription in
        subscription.select(runningGetters.getAuthenticationState)
      }
      .removeDuplicates()
      .eraseToAnyPublisher()
  }

  public func startPersistingStateChanges(to userSessionDataStore: UserSessionDataStore) {
    self.authenticationStatePublisher
      .receive(on: DispatchQueue.main)
      .dropFirst(1)
      .sink { [weak self] authenticationState in
        self?.on(authenticationState: authenticationState, with: userSessionDataStore)
      }
      .store(in: &subscriptions)
  }

  private func on(authenticationState: AuthenticationState?, with userSessionDataStore: UserSessionDataStore) {
    guard let authenticationState = authenticationState else {
      assertionFailure("startPersistingStateChanges called while app was launching.")
      return
    }

    switch authenticationState {
    case .notSignedIn:
      deleteUserSession(from: userSessionDataStore)
    case .signedIn(let userSession):
      persist(userSession, to: userSessionDataStore)
    }
  }

  private func persist(_ userSession: UserSession, to userSessionDataStore: UserSessionDataStore) {
    userSessionDataStore
      .save(userSession: userSession)
      .catch { error in
        assertionFailure("Failed to persist user session.")
      }
  }

  private func deleteUserSession(from userSessionDataStore: UserSessionDataStore) {
    userSessionDataStore
      .deleteUserSession()
      .catch { error in
        assertionFailure("Failed to delete user session.")
      }
  }
}
