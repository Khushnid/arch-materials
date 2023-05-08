import UIKit
import KooberUIKit
import KooberKit
import Combine

public class LaunchViewController: NiblessViewController {

  // MARK: - Properties
  // User Interactions
  let userInteractions: LaunchingUserInteractions

  // State
  let statePublisher: AnyPublisher<LaunchViewControllerState, Never>
  var subscriptions = Set<AnyCancellable>()

  // MARK: - Methods
  init(statePublisher: AnyPublisher<LaunchViewControllerState, Never>,
       userInteractions: LaunchingUserInteractions) {
    self.statePublisher = statePublisher
    self.userInteractions = userInteractions

    super.init()
  }

  public override func loadView() {
    view = LaunchRootView()
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    observeState()
    userInteractions.launchApp()
  }

  func observeState() {
    statePublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] viewControllerState in
        if let errorMessage = viewControllerState.errorsToPresent.first {
          self?.present(errorMessage: errorMessage) {
            self?.userInteractions.finishedPresenting(errorMessage: errorMessage)
          }
        }
      }
      .store(in: &subscriptions)
  }
}
