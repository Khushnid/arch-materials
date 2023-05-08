import UIKit
import KooberUIKit
import KooberKit

public class WelcomeViewController: NiblessViewController {
    
    // MARK: - Properties
    let userInteractions: WelcomeUserInteractions
    
    // MARK: - Methods
    init(userInteractions: WelcomeUserInteractions) {
        self.userInteractions = userInteractions
        super.init()
    }
    
    public override func loadView() {
        view = WelcomeRootView(userInteractions: userInteractions)
    }
}
