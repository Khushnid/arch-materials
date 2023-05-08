import Foundation

public class ReduxProfileUserInteractions: ProfileUserInteractions {
    
    // MARK: - Properties
    let actionDispatcher: ActionDispatcher
    let userSession: UserSession
    
    // MARK: - Methods
    public init(actionDispatcher: ActionDispatcher,
                userSession: UserSession) {
        self.actionDispatcher = actionDispatcher
        self.userSession = userSession
    }
    
    public func signOut() {
        let action = AppRunningActions.SignOut()
        actionDispatcher.dispatch(action)
    }
    
    public func dismissProfile() {
        let action = SignedInActions.DismissProfile()
        actionDispatcher.dispatch(action)
    }
    
    public func finishedPresenting(_ errorMessage: ErrorMessage) {
        let action = ProfileActions.FinishedPresentingError(errorMessage: errorMessage)
        actionDispatcher.dispatch(action)
    }
}
