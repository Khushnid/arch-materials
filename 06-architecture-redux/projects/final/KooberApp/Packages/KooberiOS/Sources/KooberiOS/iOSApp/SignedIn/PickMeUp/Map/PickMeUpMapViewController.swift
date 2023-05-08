import UIKit
import KooberUIKit
import KooberKit
import Combine

public class PickMeUpMapViewController: NiblessViewController {
    
    // MARK: - Properties
    // Dependencies
    let imageCache: ImageCache
    
    // State
    let statePublisher: AnyPublisher<MapViewControllerState, Never>
    var subscriptions = Set<AnyCancellable>()
    
    // Root View
    var mapView: PickMeUpMapRootView {
        return view as! PickMeUpMapRootView
    }
    
    // MARK: - Methods
    public init(statePublisher: AnyPublisher<MapViewControllerState, Never>,
                imageCache: ImageCache) {
        self.statePublisher = statePublisher
        self.imageCache = imageCache
        super.init()
    }
    
    public override func loadView() {
        view = PickMeUpMapRootView(imageCache: imageCache)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.imageCache = imageCache
        observeState()
    }
    
    func observeState() {
        statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mapViewControllerState in
                self?.mapView.pickupLocation = mapViewControllerState.pickupLocation
                self?.mapView.dropoffLocation = mapViewControllerState.dropoffLocation
            }
            .store(in: &subscriptions)
    }
}
