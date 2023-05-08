import Foundation

public struct RideOptionSegmentedControlState: Equatable {
    
    // MARK: - Properties
    public var segments: [RideOptionSegmentState]
    
    // MARK: - Methods
    public init(segments: [RideOptionSegmentState] = []) {
        self.segments = segments
    }
}
