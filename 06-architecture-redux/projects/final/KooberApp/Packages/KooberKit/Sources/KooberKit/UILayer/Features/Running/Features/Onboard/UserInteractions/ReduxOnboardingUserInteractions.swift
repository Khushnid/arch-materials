import Foundation
import ReSwift

public class ReduxOnboardingUserInteractions: OnboardingUserInteractions {
    
    // MARK: - Properties
    let actionDispatcher: ActionDispatcher
    
    // MARK: - Methods
    public init(actionDispatcher: ActionDispatcher) {
        self.actionDispatcher = actionDispatcher
    }
    
    public func navigatedBackToWelcome() {
        let action = OnboardingActions.NavigatedBackToWelcome()
        actionDispatcher.dispatch(action)
    }
}
