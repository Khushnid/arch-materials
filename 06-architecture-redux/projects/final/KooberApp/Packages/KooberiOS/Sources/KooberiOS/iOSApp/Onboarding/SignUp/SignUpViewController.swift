

import UIKit
import KooberUIKit
import KooberKit
import Combine

public class SignUpViewController: NiblessViewController {

  // MARK: - Properties
  // State
  let statePublisher: AnyPublisher<SignUpViewControllerState, Never>
  var subscriptions = Set<AnyCancellable>()

  // User Interactions
  let userInteractions: SignUpUserInteractions

  // MARK: - Methods
  init(statePublisher: AnyPublisher<SignUpViewControllerState, Never>,
       userInteractions: SignUpUserInteractions) {
    self.statePublisher = statePublisher
    self.userInteractions = userInteractions
    super.init()
  }

  public override func loadView() {
    view = SignUpRootView(userInteractions: userInteractions)
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    observeState()
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    addKeyboardObservers()
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    removeObservers()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    (view as! SignUpRootView).configureViewAfterLayout()
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
}

extension SignUpViewController {

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
          (view as! SignUpRootView).moveContentForDismissedKeyboard()
        } else {
          (view as! SignUpRootView).moveContent(forKeyboardFrame: convertedKeyboardEndFrame)
        }
    }
  }
}
