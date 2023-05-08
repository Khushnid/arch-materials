import Foundation

public protocol PickMeUpUserInteractions {
    
    func goToDropoffLocationPicker()
    func confirmNewRideRequest()
    func send(_ newRideRequest: NewRideRequest)
    func finishedRequestingNewRide()
    func finishedPresentingNewRequestError(_ errorMessage: ErrorMessage)
}
