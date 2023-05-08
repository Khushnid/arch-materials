

import UIKit
import KooberUIKit
import KooberKit
import PromiseKit

class RideOptionSegmentedControl: UIControl {

  // MARK: - Properties
  let userInteractions: RideOptionPickerUserInteractions

  var viewState = RideOptionSegmentedControlState() {
    didSet {
      if oldValue != viewState {
        loadAndRecreateButtons(withSegments: viewState.segments)
      } else {
        update(withSegments: viewState.segments)
      }
    }
  }

  private let maxRideOptionSegments = 3
  private let imageLoader: RideOptionSegmentButtonImageLoader
  private var buttons: [RideOptionID: RideOptionButton] = [:]

  private var rideOptionStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .equalSpacing
    return stackView
  }()

  // MARK: - Methods
  init(frame: CGRect = .zero,
       imageCache: ImageCache,
       userInteractions: RideOptionPickerUserInteractions) {
    self.imageLoader = RideOptionSegmentButtonImageLoader(imageCache: imageCache)
    self.userInteractions = userInteractions
    super.init(frame: frame)

    constructViewHierarchy()
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("RideOptionSegmentedControl does not support instantiation via NSCoding.")
  }

  private func constructViewHierarchy() {

    func applyConstraints(toBackgroundBanner backgroundBanner: UIView) {
      backgroundBanner.translatesAutoresizingMaskIntoConstraints = false
      backgroundBanner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
      backgroundBanner.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
      backgroundBanner.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
      backgroundBanner.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func applyConstraints(toRideOptionStackView rideOptionStackView: UIStackView) {
      rideOptionStackView.translatesAutoresizingMaskIntoConstraints = false
      rideOptionStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
      rideOptionStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
      rideOptionStackView.heightAnchor.constraint(equalToConstant: 140.0).isActive = true
      rideOptionStackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }

    let backgroundBanner = UIView()
    backgroundBanner.backgroundColor = UIColor(red: 0,
                                               green: 205/255.0,
                                               blue: 188/255.0,
                                               alpha: 1)

    addSubview(backgroundBanner)
    applyConstraints(toBackgroundBanner: backgroundBanner)

    addSubview(rideOptionStackView)
    applyConstraints(toRideOptionStackView: rideOptionStackView)
  }

  private func update(withSegments segments: [RideOptionSegmentState]) {
    segments.forEach(update(withSegment:))
  }

  private func update(withSegment segment: RideOptionSegmentState) {
    buttons[segment.id]?.isSelected = segment.isSelected
  }

  private func loadAndRecreateButtons(withSegments segments:  [RideOptionSegmentState]) {
    loadButtonImages().done { loadedSegments in
      guard loadedSegments.idsEqual(to: self.viewState.segments) else {
        return
      }
      self.recreateButtons(withSegments: loadedSegments)
      }.catch { error in
        self.recreateButtons(withSegments: segments)
      }
  }

  private func loadButtonImages() -> Promise<[RideOptionSegmentState]> {
    return imageLoader.loadImages(using: viewState.segments)
  }

  private func recreateButtons(withSegments segments: [RideOptionSegmentState]) {
    rideOptionStackView.removeAllArangedSubviews()
    segments.prefix(maxRideOptionSegments)
      .map(makeRideOptionButton(forSegment:))
      .map { id, button in
        store(button: button, forID: id)
      }
      .forEach(rideOptionStackView.addArrangedSubview)
  }

  private func makeRideOptionButton(forSegment segment: RideOptionSegmentState) -> (RideOptionID, RideOptionButton) {
    let button = RideOptionButton(segment: segment)
    button.didSelectRideOption = { [weak self] id in
      self?.userInteractions.select(rideOptionID: id)
    }
    return (segment.id, button)
  }

  private func store(button: RideOptionButton, forID id: RideOptionID) -> RideOptionButton {
    buttons[id] = button
    return button
  }
}
