import Foundation

public protocol UserSessionStatePersister {
    func startPersistingStateChanges(to userSessionDataStore: UserSessionDataStore)
}
