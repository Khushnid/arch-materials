import UIKit
import KooberUIKit
import KooberKit

class SignedInRootView: NiblessView {
    
    // MARK: - Properties
    let userInteractions: SignedInUserInteractions
    
    let goToProfileControl: UIButton = {
        let button = UIButton(type: .system)
        let profileIcon = #imageLiteral(resourceName: "person_icon")
        button.setImage(profileIcon, for: .normal)
        button.tintColor = Color.darkTextColor
        return button
    }()
    
    // MARK: - Methods
    init(frame: CGRect = .zero,
         userInteractions: SignedInUserInteractions) {
        self.userInteractions = userInteractions
        super.init(frame: frame)
        
        backgroundColor = Color.background
        
        addSubview(goToProfileControl)
        goToProfileControl.addTarget(self, action: #selector(presentProfile), for: .touchUpInside)
    }
    
    @objc
    func presentProfile() {
        userInteractions.presentProfile()
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        bringSubviewToFront(goToProfileControl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        goToProfileControl.frame = CGRect(x: frame.maxX - 85,
                                          y: 24,
                                          width: 100,
                                          height: 50)
    }
}
