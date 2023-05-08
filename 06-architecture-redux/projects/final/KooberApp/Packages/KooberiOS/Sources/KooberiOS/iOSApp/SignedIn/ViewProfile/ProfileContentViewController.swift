import UIKit
import KooberUIKit
import KooberKit
import Combine

public class ProfileContentViewController: NiblessViewController {

  // MARK: - Properties
  // State
  let statePublisher: AnyPublisher<ProfileViewControllerState, Never>
  var subscriptions = Set<AnyCancellable>()

  // User Interactions
  let userInteractions: ProfileUserInteractions

  // Root View
  var rootView: ProfileContentRootView { return view as! ProfileContentRootView }

  // MARK: - Methods
  init(statePublisher: AnyPublisher<ProfileViewControllerState, Never>,
       userInteractions: ProfileUserInteractions) {
    self.statePublisher = statePublisher
    self.userInteractions = userInteractions

    super.init()

    self.navigationItem.title = "My Profile"
    self.navigationItem.rightBarButtonItem =
      UIBarButtonItem(barButtonSystemItem: .done,
                      target: self,
                      action: #selector(dismissProfile))
  }

  public override func loadView() {
    view = ProfileContentRootView(userInteractions: userInteractions)
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    observeState()
  }

  func observeState() {
    statePublisher
      .receive(on: DispatchQueue.main)
      .map { $0.profile }
      .removeDuplicates()
      .assign(to: \.rootView.userProfile, on: self)
      .store(in: &subscriptions)

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

  @objc
  func dismissProfile() {
    userInteractions.dismissProfile()
  }
}
