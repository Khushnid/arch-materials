import Foundation

public protocol SignInUserInteractions {
  
  func signIn(email: String, password: Secret)
  func finishedPresenting(_ errorMessage: ErrorMessage)
}
