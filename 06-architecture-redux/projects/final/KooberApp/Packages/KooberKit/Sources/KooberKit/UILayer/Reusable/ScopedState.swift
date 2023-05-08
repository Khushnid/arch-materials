import Foundation

public enum ScopedState<StateType: Equatable>: Equatable {
    
    case outOfScope
    case inScope(StateType)
}
