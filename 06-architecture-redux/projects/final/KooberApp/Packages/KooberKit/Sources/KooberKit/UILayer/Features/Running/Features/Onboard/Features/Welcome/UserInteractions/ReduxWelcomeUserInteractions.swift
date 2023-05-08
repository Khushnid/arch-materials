import Foundation
import ReSwift

public class ReduxWelcomeUserInteractions: WelcomeUserInteractions {

  // MARK: - Properties
  let actionDispatcher: ActionDispatcher

  // MARK: - Methods
  public init(actionDispatcher: ActionDispatcher) {
    self.actionDispatcher = actionDispatcher
  }

  public func goToSignUp() {
    let action = WelcomeActions.GoToSignUp()
    actionDispatcher.dispatch(action)
  }

  public func goToSignIn() {
    let action = WelcomeActions.GoToSignIn()
    actionDispatcher.dispatch(action)
  }
}
