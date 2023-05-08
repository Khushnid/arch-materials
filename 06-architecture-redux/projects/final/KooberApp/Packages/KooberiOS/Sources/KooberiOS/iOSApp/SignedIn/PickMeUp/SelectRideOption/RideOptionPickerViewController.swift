

import UIKit
import KooberUIKit
import KooberKit
import Combine

public class RideOptionPickerViewController: NiblessViewController {

  // MARK: - Properties
  // Dependencies
  let imageCache: ImageCache

  // State
  let statePublisher: AnyPublisher<RideOptionPickerViewControllerState, Never>
  let pickupLocation: Location
  var selectedRideOptionID: RideOptionID?
  var subscriptions = Set<AnyCancellable>()

  // User Interactions
  let userInteractions: RideOptionPickerUserInteractions

  // Root View
  var rideOptionSegmentedControl: RideOptionSegmentedControl {
    return view as! RideOptionSegmentedControl
  }

  // MARK: - Methods
  init(pickupLocation: Location,
       statePublisher: AnyPublisher<RideOptionPickerViewControllerState, Never>,
       userInteractions: RideOptionPickerUserInteractions,
       imageCache: ImageCache) {
    self.pickupLocation = pickupLocation
    self.statePublisher = statePublisher
    self.userInteractions = userInteractions
    self.imageCache = imageCache
    super.init()
  }

  public override func loadView() {
    view = RideOptionSegmentedControl(frame: .zero,
                                      imageCache: imageCache,
                                      userInteractions: userInteractions)
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    userInteractions.loadRideOptions(availableAt: pickupLocation, screenScale: UIScreen.main.scale)
    observeState()
  }

  func observeState() {
    statePublisher
      .receive(on: DispatchQueue.main)
      .map { $0.segmentedControlState }
      .removeDuplicates()
      .sink { [weak self] segmentedControlState in
        self?.rideOptionSegmentedControl.viewState = segmentedControlState
      }
      .store(in: &subscriptions)

    statePublisher
      .receive(on: DispatchQueue.main)
      .map { $0.errorsToPresent }
      .removeDuplicates()
      .sink { [weak self] errorsToPresent in
        if let errorMessage = errorsToPresent.first {
          self?.present(errorMessage: errorMessage) {
            self?.userInteractions.finishedPresenting(errorMessage)
          }
        }
      }
      .store(in: &subscriptions)
  }

  class SegmentedControlStateReducer {

    static func reduce(from rideOptions: RideOptionPickerRideOptions) -> RideOptionSegmentedControlState {
      let segments = RideOptionSegmentsFactory(state: rideOptions).makeSegments(screenScale: UIScreen.main.scale)
      return RideOptionSegmentedControlState(segments: segments)
    }
  }
}
