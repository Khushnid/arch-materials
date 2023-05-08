import UIKit
import KooberUIKit
import KooberKit

class DropoffLocationPickerContentRootView: NiblessView {
    
    // MARK: - Properties
    let userInteractions: DropoffLocationPickerUserInteractions
    var searchResults: [NamedLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.cell.rawValue)
        tableView.insetsContentViewsToSafeArea = true
        tableView.contentInsetAdjustmentBehavior = .automatic
        return tableView
    }()
    
    // MARK: - Methods
    init(frame: CGRect = .zero,
         userInteractions: DropoffLocationPickerUserInteractions) {
        self.userInteractions = userInteractions
        
        super.init(frame: frame)
        
        addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
}

extension DropoffLocationPickerContentRootView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.cell.rawValue)
        cell?.textLabel?.text = searchResults[indexPath.row].name
        return cell!
    }
}

extension DropoffLocationPickerContentRootView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNamedLocation = searchResults[indexPath.row]
        userInteractions.select(dropoffLocation: selectedNamedLocation.location)
    }
}
