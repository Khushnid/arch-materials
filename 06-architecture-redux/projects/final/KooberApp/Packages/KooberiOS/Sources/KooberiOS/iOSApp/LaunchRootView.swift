import Foundation
import CoreGraphics
import KooberUIKit

class LaunchRootView: NiblessView {
    
    // MARK: - Methods
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        styleView()
    }
    
    private func styleView() {
        backgroundColor = Color.background
    }
}
