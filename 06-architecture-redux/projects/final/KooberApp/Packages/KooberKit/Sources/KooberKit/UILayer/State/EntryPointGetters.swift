import Foundation

public struct EntryPointGetters {

  // MARK: - Methods
  public init() {}

  public func getLaunchViewControllerState(appState: AppState) -> ScopedState<LaunchViewControllerState> {
    switch appState {
    case .launching(let launchViewControllerState):
      return .inScope(launchViewControllerState)
    default:
      return .outOfScope
    }
  }

  public func getAppRunningState(appState: AppState) -> ScopedState<AppRunningState> {
    switch appState {
    case .running(let appRunningState):
      return .inScope(appRunningState)
    default:
      return .outOfScope
    }
  }
}
