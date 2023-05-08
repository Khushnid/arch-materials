import Foundation
import ReSwift

struct ProfileActions {
    
    struct SignOutFailed: Action {
        
        // MARK: - Properties
        let errorMessage: ErrorMessage
    }
    
    struct FinishedPresentingError: Action {
        
        // MARK: - Properties
        let errorMessage: ErrorMessage
    }
}
