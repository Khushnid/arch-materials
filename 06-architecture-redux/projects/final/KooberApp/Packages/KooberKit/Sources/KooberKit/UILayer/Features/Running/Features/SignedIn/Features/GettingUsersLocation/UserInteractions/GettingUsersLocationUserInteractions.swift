import Foundation

public protocol GettingUsersLocationUserInteractions {
    
    func getUsersLocation()
    func finishedPresenting(_ errorMessage: ErrorMessage)
}
