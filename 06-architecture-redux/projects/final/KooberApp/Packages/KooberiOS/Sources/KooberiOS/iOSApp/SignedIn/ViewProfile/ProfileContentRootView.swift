import UIKit
import KooberUIKit
import KooberKit

class ProfileContentRootView: NiblessView {
    
    // MARK: - Properties
    var userProfile: UserProfile? {
        didSet {
            guard let userProfile = userProfile else { return }
            presentTableView(userProfile)
            tableView?.reloadData()
        }
    }
    
    let userInteractions: ProfileUserInteractions
    var tableView: UITableView?
    
    // MARK: - Methods
    init(frame: CGRect = .zero,
         userInteractions: ProfileUserInteractions) {
        self.userInteractions = userInteractions
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView?.frame = bounds
    }
    
    func presentTableView(_ userProfle: UserProfile) {
        guard self.tableView == nil else { return }
        
        let newTableView = makeTableView(userProfile: userProfle,
                                         userInteractions: userInteractions)
        addSubview(newTableView)
        self.tableView = newTableView
    }
    
    func makeTableView(userProfile: UserProfile, userInteractions: ProfileUserInteractions) -> UITableView {
        return ProfileTableView(frame: .zero,
                                style: .grouped,
                                userProfile: userProfile,
                                userInteractions: userInteractions)
    }
}
