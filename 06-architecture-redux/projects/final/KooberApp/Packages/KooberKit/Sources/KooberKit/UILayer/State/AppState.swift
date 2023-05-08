

import Foundation
import ReSwift

public enum AppState: Equatable {
  
  case launching(LaunchViewControllerState)
  case running(AppRunningState)
}


