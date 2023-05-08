import Foundation
import ReSwift

public let printActionMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            print()
            print("\(action), Action dispatched.")
            next(action)
            print("new state: \n\(String(describing: getState()))")
            print()
            print()
            return
        }
    }
}
