

import UIKit
import KooberUIKit
import KooberKit
import Combine

public class DropoffLocationPickerContentViewController: NiblessViewController {

  // MARK: - Properties
  // State
  let pickupLocation: Location
  let statePublisher: AnyPublisher<DropoffLocationPickerViewControllerState, Never>
  var subscriptions = Set<AnyCancellable>()

  // User Interactions
  let userInteractions: DropoffLocationPickerUserInteractions

  // Root View
  var rootView: DropoffLocationPickerContentRootView {
    return view as! DropoffLocationPickerContentRootView
  }

  // MARK: - Methods
  init(pickupLocation: Location,
       statePublisher: AnyPublisher<DropoffLocationPickerViewControllerState, Never>,
       userInteractions: DropoffLocationPickerUserInteractions) {
    self.pickupLocation = pickupLocation
    self.statePublisher = statePublisher
    self.userInteractions = userInteractions

    super.init()

    self.navigationItem.title = "Where To?"
    self.navigationItem.largeTitleDisplayMode = .automatic
    self.navigationItem.leftBarButtonItem =
      UIBarButtonItem(barButtonSystemItem: .cancel,
                      target: self,
                      action: #selector(cancelDropoffLocationPicker))
  }

  public override func loadView() {
    view = DropoffLocationPickerContentRootView(userInteractions: userInteractions)
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    setUpSearchController()
    observeState()
  }

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    userInteractions.searchForDropoffLocations(using: "", for: pickupLocation)
  }

  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    navigationItem.searchController?.isActive = false
  }

  func setUpSearchController() {
    let pickupLocationCopy = self.pickupLocation
    let searchController = ObservableUISearchController(searchResultsController: nil)
    searchController.obscuresBackgroundDuringPresentation = false

    searchController.searchTextPublisher
      .receive(on: DispatchQueue.main)
      .debounce(for: .milliseconds(900), scheduler: DispatchQueue.main)
      .sink { [weak self] query in
        self?.userInteractions.searchForDropoffLocations(using: query, for: pickupLocationCopy)
      }
      .store(in: &subscriptions)

    navigationItem.searchController = searchController
    definesPresentationContext = true
  }

  func observeState() {
    statePublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] viewControllerState in
        self?.rootView.searchResults = viewControllerState.searchResults
      }
      .store(in: &subscriptions)

    statePublisher
      .receive(on: DispatchQueue.main)
      .map { $0.errorsToPresent }
      .removeDuplicates()
      .sink { [weak self] errorsToPresent in
        if let errorMessage = errorsToPresent.first {
          if let presentedViewController = self?.presentedViewController {
            presentedViewController.present(errorMessage: errorMessage) {
              self?.userInteractions.finishedPresenting(errorMessage)
            }
          } else {
            self?.present(errorMessage: errorMessage) {
              self?.userInteractions.finishedPresenting(errorMessage)
            }
          }
        }
      }
      .store(in: &subscriptions)
  }

  @objc
  func cancelDropoffLocationPicker() {
    userInteractions.cancelDropoffLocationPicker()
  }
}

