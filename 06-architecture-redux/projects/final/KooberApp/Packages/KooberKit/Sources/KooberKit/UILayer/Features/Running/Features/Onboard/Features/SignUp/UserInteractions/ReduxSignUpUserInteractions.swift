

import Foundation
import PromiseKit

public class ReduxSignUpUserInteractions: SignUpUserInteractions {

  // MARK: - Properties
  let actionDispatcher: ActionDispatcher
  let remoteAPI: AuthRemoteAPI

  // MARK: - Methods
  public init(actionDispatcher: ActionDispatcher,
              remoteAPI: AuthRemoteAPI) {
    self.actionDispatcher = actionDispatcher
    self.remoteAPI = remoteAPI
  }

  public func signUp(_ newAccount: NewAccount) {
    remoteAPI.signUp(account: newAccount)
      .done(signedIn(to:))
      .catch(handleSignUpError)
  }

  private func signedIn(to userSession: UserSession) {
    let action = SignInActions.SignedIn(userSession: userSession)
    actionDispatcher.dispatch(action)
  }

  private func handleSignUpError(_ error: Error) {
    let errorMessage = ErrorMessage(title: "Sign Up Failed",
                                    message: "Could not sign up.\nPlease try again.")
    let action = SignUpActions.SignUpFailed(errorMessage: errorMessage)
    actionDispatcher.dispatch(action)
  }

  public func finishedPresenting(_ errorMessage: ErrorMessage) {
    let action = SignUpActions.FinishedPresentingError(errorMessage: errorMessage)
    actionDispatcher.dispatch(action)
  }
}
