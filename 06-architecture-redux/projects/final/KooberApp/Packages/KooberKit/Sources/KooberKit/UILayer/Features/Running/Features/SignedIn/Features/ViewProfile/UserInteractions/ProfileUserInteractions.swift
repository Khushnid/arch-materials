import Foundation

public protocol ProfileUserInteractions {
    func signOut()
    func dismissProfile()
    func finishedPresenting(_ errorMessage: ErrorMessage)
}
