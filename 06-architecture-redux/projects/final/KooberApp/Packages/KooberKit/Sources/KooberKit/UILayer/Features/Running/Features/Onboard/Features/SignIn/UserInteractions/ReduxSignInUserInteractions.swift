import Foundation
import ReSwift
import PromiseKit

public class ReduxSignInUserInteractions: SignInUserInteractions {

  // MARK: - Properties
  let actionDispatcher: ActionDispatcher
  let remoteAPI: AuthRemoteAPI

  // MARK: - Methods
  public init(actionDispatcher: ActionDispatcher,
              remoteAPI: AuthRemoteAPI) {
    self.actionDispatcher = actionDispatcher
    self.remoteAPI = remoteAPI
  }

  public func signIn(email: String, password: Secret) {
    indicateSigningIn()
    remoteAPI.signIn(username: email, password: password)
      .done(signedIn(to:))
      .catch(indicateErrorSigningIn)

  }

  private func indicateSigningIn() {
    let action = SignInActions.SigningIn()
    actionDispatcher.dispatch(action)
  }

  private func signedIn(to userSession: UserSession) {
    let action = SignInActions.SignedIn(userSession: userSession)
    actionDispatcher.dispatch(action)
  }

  private func indicateErrorSigningIn(error: Error) {
    let errorMessage = ErrorMessage(title: "Sign In Failed",
                                    message: "Could not sign in.\nPlease try again.")
    let action = SignInActions.SignInFailed(errorMessage: errorMessage)
    actionDispatcher.dispatch(action)
  }

  public func finishedPresenting(_ errorMessage: ErrorMessage) {
    let action = SignInActions.FinishedPresentingError(errorMessage: errorMessage)
    actionDispatcher.dispatch(action)
  }
}
