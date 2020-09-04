import UIKit

class SignificantChangesViewController: UIViewController, LocationHelperRequiring {
  var locationHelper: LocationHelper!
  
  @IBOutlet var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    locationHelper.monitorSignificantChanges { [weak self] _ in
      self?.tableView.reloadData()
    }
    
    tableView.reloadData()
  }
}

extension SignificantChangesViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return locationHelper.trackedLocations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
    let location = locationHelper.trackedLocations[indexPath.row]
    
    cell.textLabel?.text = "\(location.coordinate.latitude) / \(location.coordinate.longitude)"
    cell.detailTextLabel?.text = "\(location.timestamp)"
    
    return cell
  }
}
