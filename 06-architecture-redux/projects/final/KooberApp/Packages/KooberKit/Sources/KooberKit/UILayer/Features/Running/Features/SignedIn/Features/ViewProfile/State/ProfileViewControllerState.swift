

import Foundation

public struct ProfileViewControllerState: Equatable {

  // MARK: - Properties
  public internal(set) var profile: UserProfile
  public internal(set) var errorsToPresent: Set<ErrorMessage>
}
