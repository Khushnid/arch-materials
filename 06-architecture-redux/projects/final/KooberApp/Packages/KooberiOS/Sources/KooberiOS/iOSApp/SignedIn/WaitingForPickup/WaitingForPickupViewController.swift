

import UIKit
import KooberUIKit
import KooberKit

public class WaitingForPickupViewController: NiblessViewController {

  // MARK: - Properties
  let userInteractions: WaitingForPickupUserInteractions

  // MARK: - Methods
  init(userInteractions: WaitingForPickupUserInteractions) {
    self.userInteractions = userInteractions
    super.init()
  }

  override public func loadView() {
    view = WaitingForPickupRootView(userInteractions: userInteractions)
  }
}
