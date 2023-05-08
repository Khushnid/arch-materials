import Foundation

public protocol SignUpUserInteractions {
    
    func signUp(_ newAccount: NewAccount)
    func finishedPresenting(_ errorMessage: ErrorMessage)
}
