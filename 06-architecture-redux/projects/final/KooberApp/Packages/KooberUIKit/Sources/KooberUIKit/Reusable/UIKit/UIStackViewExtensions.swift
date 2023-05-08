import UIKit

extension UIStackView {
  public func removeAllArangedSubviews() {
    arrangedSubviews.forEach { $0.removeFromSuperview() }
  }
}
