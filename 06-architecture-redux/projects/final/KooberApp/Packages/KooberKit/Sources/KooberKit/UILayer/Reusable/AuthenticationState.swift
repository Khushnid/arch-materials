import Foundation

public enum AuthenticationState: Equatable {
    
    case notSignedIn
    case signedIn(UserSession)
    
    init(userSession: UserSession?) {
        if let userSession = userSession {
            self = .signedIn(userSession)
        } else {
            self = .notSignedIn
        }
    }
}
