import UIKit
import KooberiOS
import KooberUIKit
import KooberKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  let injectionContainer = KooberAppDependencyContainer()
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let mainVC = injectionContainer.makeMainViewController()
    
    let window = UIWindow()
    window.frame = UIScreen.main.bounds
    window.makeKeyAndVisible()
    window.rootViewController = mainVC
    self.window = window
    
    return true
  }
}
