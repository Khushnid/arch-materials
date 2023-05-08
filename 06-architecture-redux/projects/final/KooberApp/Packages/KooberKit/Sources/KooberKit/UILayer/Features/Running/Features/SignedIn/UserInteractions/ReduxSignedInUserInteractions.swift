import Foundation

public class ReduxSignedInUserInteractions: SignedInUserInteractions {
    
    // MARK: - Properties
    let actionDispatcher: ActionDispatcher
    
    // MARK: - Methods
    public init(actionDispatcher: ActionDispatcher) {
        self.actionDispatcher = actionDispatcher
    }
    
    public func presentProfile() {
        let action = SignedInActions.ViewProfile()
        actionDispatcher.dispatch(action)
    }
}
