import Foundation
import ReSwift

struct GettingUsersLocationActions {
    
    struct FailedGettingUsersLocation: Action {
        
        // MARK: - Properties
        let errorMessage: ErrorMessage
    }
    
    struct FinishedPresentingError: Action {
        
        // MARK: - Properties
        let errorMessage: ErrorMessage
    }
}
