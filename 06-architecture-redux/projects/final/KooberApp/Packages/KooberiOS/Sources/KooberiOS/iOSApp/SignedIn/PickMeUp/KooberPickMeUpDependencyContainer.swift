import UIKit
import KooberUIKit
import KooberKit
import Combine
import ReSwift

public class KooberPickMeUpDependencyContainer {
    
    // MARK: - Properties
    
    // From parent container
    let imageCache: ImageCache
    let actionDispatcher: ActionDispatcher
    let stateStore: Store<AppState>
    let signedInGetters: SignedInGetters
    let newRideRemoteAPI: NewRideRemoteAPI
    let rideOptionDataStore: RideOptionDataStore
    
    let pickupLocation: Location
    
    let pickMeUpStateGetters: PickMeUpGetters
    
    // MARK: - Methods
    init(pickupLocation: Location, signedInDependencyContainer: KooberSignedInDependencyContainer) {
        self.imageCache = signedInDependencyContainer.imageCache
        self.actionDispatcher = signedInDependencyContainer.stateStore
        self.stateStore = signedInDependencyContainer.stateStore
        self.signedInGetters = signedInDependencyContainer.signedInGetters
        self.newRideRemoteAPI = signedInDependencyContainer.newRideRemoteAPI
        self.rideOptionDataStore = signedInDependencyContainer.rideOptionDataStore
        
        self.pickupLocation = pickupLocation
        self.pickMeUpStateGetters = PickMeUpGetters(getPickMeUpState: signedInGetters.getPickMeUpViewControllerState)
    }
    
    // Pick Me Up (container view controller)
    public func makePickMeUpViewController() -> PickMeUpViewController {
        let statePublisher = makePickMeUpViewControllerStatePublisher()
        let userInteractions = makePickMeUpUserInteractions()
        let mapViewController = makePickMeUpMapViewController()
        let rideOptionPickerViewController = makeRideOptionPickerViewController()
        let sendingRideRequestViewController = makeSendingRideRequestViewController()
        return PickMeUpViewController(statePublisher: statePublisher,
                                      userInteractions: userInteractions,
                                      mapViewController: mapViewController,
                                      rideOptionPickerViewController: rideOptionPickerViewController,
                                      sendingRideRequestViewController: sendingRideRequestViewController,
                                      viewControllerFactory: self)
    }
    
    public func makePickMeUpViewControllerStatePublisher() -> AnyPublisher<PickMeUpViewControllerState, Never> {
        let statePublisher =
        stateStore
            .publisher { subscription in
                subscription.select(self.signedInGetters.getPickMeUpViewControllerState)
            }
        return statePublisher
    }
    
    public func makePickMeUpUserInteractions() -> PickMeUpUserInteractions {
        let newRideRepository = makeNewRideRepository()
        return ReduxPickMeUpUserInteractions(actionDispatcher: actionDispatcher,
                                             newRideRepository: newRideRepository)
    }
    
    public func makeNewRideRepository() -> NewRideRepository {
        return KooberNewRideRepository(remoteAPI: newRideRemoteAPI)
    }
    
    // Map
    func makePickMeUpMapViewController() -> PickMeUpMapViewController {
        let statePublisher = makeMapViewControllerStatePublisher()
        return PickMeUpMapViewController(statePublisher: statePublisher,
                                         imageCache: imageCache)
    }
    
    public func makeMapViewControllerStatePublisher() -> AnyPublisher<MapViewControllerState, Never> {
        let statePublisher =
        stateStore
            .publisher { subscription in
                subscription.select(self.pickMeUpStateGetters.getMapViewControllerState)
            }
        return statePublisher
    }
    
    // Dropoff Location Picker
    public func makeDropoffLocationPickerViewController() -> DropoffLocationPickerViewController {
        let contentViewController = makeDropoffLocationPickerContentViewController()
        return DropoffLocationPickerViewController(contentViewController: contentViewController)
    }
    
    func makeDropoffLocationPickerContentViewController() -> DropoffLocationPickerContentViewController {
        let statePublisher = makeDropoffLocationPickerViewControllerStatePublisher()
        let userInteractions = makeDropoffLocationPickerUserInteractions()
        return DropoffLocationPickerContentViewController(pickupLocation: pickupLocation,
                                                          statePublisher: statePublisher,
                                                          userInteractions: userInteractions)
    }
    
    public func makeDropoffLocationPickerViewControllerStatePublisher() -> AnyPublisher<DropoffLocationPickerViewControllerState, Never> {
        let statePublisher =
        stateStore
            .publisher { subscription in
                subscription.select(self.pickMeUpStateGetters.getDropoffLocationPickerViewControllerState)
            }
        return statePublisher
    }
    
    public func makeDropoffLocationPickerUserInteractions() -> DropoffLocationPickerUserInteractions {
        let locationRepository = makeLocationRepository()
        return ReduxDropoffLocationPickerUserInteractions(actionDispatcher: actionDispatcher,
                                                          locationRepository: locationRepository)
    }
    
    public func makeLocationRepository() -> LocationRepository {
        return KooberLocationRepository(remoteAPI: newRideRemoteAPI)
    }
    
    // Ride-option picker
    public func makeRideOptionPickerViewController() -> RideOptionPickerViewController {
        let statePublisher = makeRideOptionPickerViewControllerStatePublisher()
        let userInteractions = makeRideOptionPickerUserInteractions()
        return RideOptionPickerViewController(pickupLocation: pickupLocation,
                                              statePublisher: statePublisher,
                                              userInteractions: userInteractions,
                                              imageCache: imageCache)
    }
    
    public func makeRideOptionPickerViewControllerStatePublisher() -> AnyPublisher<RideOptionPickerViewControllerState, Never> {
        let statePublisher =
        stateStore
            .publisher { subscription in
                subscription.select(self.pickMeUpStateGetters.getRideOptionPickerViewControllerState)
            }
        return statePublisher
    }
    
    public func makeRideOptionPickerUserInteractions() -> RideOptionPickerUserInteractions {
        let repository = makeRideOptionRepository()
        return ReduxRideOptionPickerUserInteractions(actionDispatcher: actionDispatcher,
                                                     rideOptionRepository: repository)
    }
    
    public func makeRideOptionRepository() -> RideOptionRepository {
        return KooberRideOptionRepository(remoteAPI: newRideRemoteAPI,
                                          datastore: rideOptionDataStore)
    }
    
    // Sending ride request
    public func makeSendingRideRequestViewController() -> SendingRideRequestViewController {
        return SendingRideRequestViewController()
    }
}

extension KooberPickMeUpDependencyContainer: PickMeUpViewControllerFactory {}
