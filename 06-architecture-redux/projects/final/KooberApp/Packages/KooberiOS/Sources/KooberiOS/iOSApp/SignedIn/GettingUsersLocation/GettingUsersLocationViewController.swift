import UIKit
import KooberUIKit
import KooberKit
import Combine

public class GettingUsersLocationViewController: NiblessViewController {

  // MARK: - Properties
  // State
  let statePublisher: AnyPublisher<GettingUsersLocationViewControllerState, Never>
  var subscriptions = Set<AnyCancellable>()

  // User Interactions
  let userInteractions: GettingUsersLocationUserInteractions

  // MARK: - Methods
  init(statePublisher: AnyPublisher<GettingUsersLocationViewControllerState, Never>,
       userInteractions: GettingUsersLocationUserInteractions) {
    self.statePublisher = statePublisher
    self.userInteractions = userInteractions
    super.init()
  }

  override public func loadView() {
    view = GettingUsersLocationRootView()
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    observeState()
    userInteractions.getUsersLocation()
  }

  func observeState() {
    statePublisher
      .receive(on: DispatchQueue.main)
      .map { $0.errorsToPresent }
      .removeDuplicates()
      .sink { [weak self] errorsToPresent in
        if let errorMessage = errorsToPresent.first {
          self?.present(errorMessage: errorMessage) {
            self?.userInteractions.finishedPresenting(errorMessage)
          }
        }
      }
      .store(in: &subscriptions)
  }
}
