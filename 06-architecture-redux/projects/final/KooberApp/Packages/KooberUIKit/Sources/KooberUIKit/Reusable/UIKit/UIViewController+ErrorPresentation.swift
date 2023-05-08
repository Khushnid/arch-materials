import Foundation
import UIKit
import KooberKit

extension UIViewController {
  public func present(errorMessage: ErrorMessage) {
    let errorAlertController = UIAlertController(title: errorMessage.title,
                                                 message: errorMessage.message,
                                                 preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default)
    errorAlertController.addAction(okAction)
    present(errorAlertController, animated: true, completion: nil)
  }

  public func present(errorMessage: ErrorMessage,
                      onComplete: @escaping () -> Void) {
    let errorAlertController = UIAlertController(title: errorMessage.title,
                                                 message: errorMessage.message,
                                                 preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
      onComplete()
    }
    errorAlertController.addAction(okAction)
    present(errorAlertController, animated: true, completion: nil)
  }
}
