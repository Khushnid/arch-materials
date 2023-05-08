import Foundation

public struct LaunchViewControllerState: Equatable {
    
    // MARK: - Properties
    public internal(set) var errorsToPresent: Set<ErrorMessage> = []
    
    // MARK: - Methods
    public init() {}
}
