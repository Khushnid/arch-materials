import Foundation

public enum MainViewControllerState: Equatable {
    case launching
    case onboarding
    case signedIn(UserSession)
    
    public static func mainViewControllerState(fromAppState appState: AppState) -> MainViewControllerState {
        switch appState {
        case .launching:
            return .launching
        case let .running(runningState):
            switch runningState {
            case .onboarding:
                return .onboarding
            case let .signedIn(_, userSession):
                return .signedIn(userSession)
            }
        }
    }
}
