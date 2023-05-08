import Foundation

public protocol LaunchingUserInteractions {
    func launchApp()
    func finishedPresenting(errorMessage: ErrorMessage)
}
