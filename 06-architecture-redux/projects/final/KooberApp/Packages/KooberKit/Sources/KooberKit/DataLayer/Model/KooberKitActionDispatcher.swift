import Foundation
import ReSwift

public protocol ActionDispatcher {

  func dispatch(_ action: Action)
}

extension Store: ActionDispatcher {}
