

import Foundation
import PromiseKit

public class FakeUserSessionDataStore: UserSessionDataStore {

  // MARK: - Properties
  let fakeProfile = UserProfile(name: "", email: "", mobileNumber: "", avatar: makeURL())
  let fakeRemoteSession = RemoteUserSession(token: "1234")
  var fakeUserSession: UserSession {
    return UserSession(profile: fakeProfile, remoteSession: fakeRemoteSession)
  }
  let hasToken: Bool

  // MARK: - Methods
  init(hasToken: Bool) {
    self.hasToken = hasToken
  }

  public func save(userSession: UserSession) -> Promise<UserSession> {
    return .value(userSession)
  }

  public func deleteUserSession() -> Promise<Void> {
    return .value(())
  }

  public func readUserSession() -> Promise<UserSession?> {
    switch hasToken {
    case true:
      return runHasToken()
    case false:
      return runDoesNotHaveToken()
    }
  }

  public func runHasToken() -> Promise<UserSession?> {
    print("Try to read user session from fake disk...")
    print("  simulating having user session with token 4321...")
    print("  returning user session with token 4321...")
    return .value(fakeUserSession)
  }

  func runDoesNotHaveToken() -> Promise<UserSession?> {
    print("Try to read user session from fake disk...")
    print("  simulating empty disk...")
    print("  returning nil...")
    return .value(nil)
  }
}
