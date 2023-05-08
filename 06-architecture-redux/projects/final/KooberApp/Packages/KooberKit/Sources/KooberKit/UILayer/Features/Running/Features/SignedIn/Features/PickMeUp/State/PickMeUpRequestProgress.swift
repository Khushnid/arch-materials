import Foundation

public enum PickMeUpRequestProgress: Equatable {
    case initial(pickupLocation: Location)
    case waypointsDetermined(waypoints: NewRideWaypoints)
    case rideRequestReady(rideRequest: NewRideRequest)
}
