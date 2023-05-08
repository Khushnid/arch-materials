import Foundation
import CoreGraphics

public protocol RideOptionPickerUserInteractions {
  
  func loadRideOptions(availableAt pickupLocation: Location, screenScale: CGFloat)
  func select(rideOptionID: RideOptionID)
  func finishedPresenting(_ errorMessage: ErrorMessage)
}
