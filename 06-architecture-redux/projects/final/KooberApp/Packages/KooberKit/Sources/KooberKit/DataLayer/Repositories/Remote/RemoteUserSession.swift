import Foundation

public struct RemoteUserSession: Codable, Equatable {

  // MARK: - Properties
  let token: AuthToken

  // MARK: - Methods
  public init(token: AuthToken) {
    self.token = token
  }
}
