import Foundation
import ReSwift

struct DropoffLocationPickerActions {

  struct CancelDropoffLocationPicker: Action {}

  struct NewLocationSearch: Action {

    // MARK: - Properties
    let searchID: UUID
  }

  struct LocationSearchComplete: Action {

    // MARK: - Properties
    let searchID: UUID
    let searchResults: [NamedLocation]
  }

  struct DropoffLocationSelected: Action {

    // MARK: - Properties
    let dropoffLocation: Location
  }

  struct LocationSearchFailed: Action {

    // MARK: - Properties
    let errorMessage: ErrorMessage
  }

  struct FinishedPresentingError: Action {

    // MARK: - Properties
    let errorMessage: ErrorMessage
  }
}
