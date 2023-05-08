import Foundation
import PromiseKit

class InMemoryUserSessionDataStore: UserSessionDataStore {
    
    // MARK: - Properties
    private var userSession: UserSession?
    
    // MARK: - Methods
    func readUserSession() -> Promise<UserSession?> {
        return .value(userSession)
    }
    
    func save(userSession: UserSession) -> Promise<(UserSession)> {
        self.userSession = userSession
        return .value(userSession)
    }
    
    func deleteUserSession() -> Promise<Void> {
        self.userSession = nil
        return .value(())
    }
}
