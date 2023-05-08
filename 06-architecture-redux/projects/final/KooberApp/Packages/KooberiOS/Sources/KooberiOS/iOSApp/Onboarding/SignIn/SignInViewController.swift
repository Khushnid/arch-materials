import UIKit
import KooberUIKit
import KooberKit
import PromiseKit
import Combine

public class SignInViewController: NiblessViewController {

  // MARK: - Properties
  // State
  let statePublisher: AnyPublisher<SignInViewControllerState, Never>
  var subscriptions = Set<AnyCancellable>()

  // View
  var rootView: SignInRootView { return view as! SignInRootView }

  // User Interactions
  let userInteractions: SignInUserInteractions

  // MARK: - Methods
  init(state: AnyPublisher<SignInViewControllerState, Never>,
       userInteractions: SignInUserInteractions) {
    self.statePublisher = state
    self.userInteractions = userInteractions
    super.init()
  }

  public override func loadView() {
    self.view = SignInRootView(userInteractions: userInteractions)
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    addKeyboardObservers()
    observeState()
    observeViewState()
  }

  func observeState() {
    statePublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] viewControllerState in
        if let errorMessage = viewControllerState.errorsToPresent.first {
          self?.present(errorMessage: errorMessage) {
            self?.userInteractions.finishedPresenting(errorMessage)
          }
        }
      }
      .store(in: &subscriptions)
  }

  func observeViewState() {
    statePublisher
      .receive(on: DispatchQueue.main)
      .map { $0.viewState }
      .removeDuplicates()
      .sink { [weak self] viewState in
        self?.rootView.new(state: viewState)
      }
      .store(in: &subscriptions)
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    removeObservers()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    rootView.configureViewAfterLayout()
  }
}

extension SignInViewController {

  func addKeyboardObservers() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }
  
  func removeObservers() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.removeObserver(self)
  }
  
  @objc func handleContentUnderKeyboard(notification: Notification) {
    if let userInfo = notification.userInfo,
      let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let convertedKeyboardEndFrame = view.convert(keyboardEndFrame.cgRectValue, from: view.window)
      if notification.name == UIResponder.keyboardWillHideNotification {
        (view as! SignInRootView).moveContentForDismissedKeyboard()
      } else {
        (view as! SignInRootView).moveContent(forKeyboardFrame: convertedKeyboardEndFrame)
      }
    }
  }
}
