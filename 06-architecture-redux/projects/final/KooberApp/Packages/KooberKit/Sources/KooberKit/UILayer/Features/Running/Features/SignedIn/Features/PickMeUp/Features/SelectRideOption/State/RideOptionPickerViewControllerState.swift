import Foundation

public struct RideOptionPickerViewControllerState: Equatable {
    
    // MARK: - Properties
    public internal(set) var segmentedControlState: RideOptionSegmentedControlState
    public internal(set) var errorsToPresent: Set<ErrorMessage>
}
