import Foundation
import ReSwift

extension Reducers {
  
  static func dropoffLocationPickerReducer(action: Action, state: DropoffLocationPickerViewControllerState) -> DropoffLocationPickerViewControllerState {
    var state = state

    switch action {
    case let action as DropoffLocationPickerActions.NewLocationSearch:
      state.currentSearchID = action.searchID
    case let action as DropoffLocationPickerActions.LocationSearchComplete:
      guard action.searchID == state.currentSearchID else { break }
      state.searchResults = action.searchResults
    case let action as DropoffLocationPickerActions.LocationSearchFailed:
      state.errorsToPresent.insert(action.errorMessage)
    case let action as DropoffLocationPickerActions.FinishedPresentingError:
      state.errorsToPresent.remove(action.errorMessage)
    default:
      break
    }

    return state
  }
}
