import Foundation
import CoreGraphics
import UIKit
import KooberUIKit
import KooberKit

class ProfileTableView: NiblessTableView {
    
    // MARK: - Properties
    let userProfile: UserProfile
    let userInteractions: ProfileUserInteractions
    
    // MARK: - Methods
    init(frame: CGRect = .zero,
         style: UITableView.Style,
         userProfile: UserProfile,
         userInteractions: ProfileUserInteractions) {
        self.userProfile = userProfile
        self.userInteractions = userInteractions
        
        super.init(frame: frame, style: style)
        
        register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.cell.rawValue)
        dataSource = self
        delegate = self
    }
}

extension ProfileTableView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.cell.rawValue)
        cell?.textLabel?.text = content(forIndexPath: indexPath)
        styleCell(forIndexPath: indexPath, cell: cell)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1,
           indexPath.row == 0 {
            userInteractions.signOut()
        }
    }
    
    func styleCell(forIndexPath indexPath: IndexPath, cell: UITableViewCell?) {
        if indexPath.section == 1 {
            cell?.textLabel?.textAlignment = .center
            cell?.textLabel?.textColor = UIColor(0xF2333B)
        }
    }
    
    func content(forIndexPath indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return userProfile.name
            case 1:
                return userProfile.email
            case 2:
                return userProfile.mobileNumber
            default:
                fatalError()
            }
        case 1:
            return "Sign Out"
        default:
            fatalError()
        }
    }
}
