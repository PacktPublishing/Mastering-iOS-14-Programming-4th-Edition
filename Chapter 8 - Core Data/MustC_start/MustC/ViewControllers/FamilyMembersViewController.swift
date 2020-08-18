import UIKit

class FamilyMembersViewController: UIViewController, AddFamilyMemberDelegate {
  
  @IBOutlet var tableView: UITableView!
  
  func saveFamilyMember(withName name: String) {
    // implement  later
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let navVC = segue.destination as? UINavigationController,
      let addFamilyMemberVC = navVC.viewControllers[0] as? AddFamilyMemberViewController {
      
      addFamilyMemberVC.delegate = self
    }
    
    guard let selectedIndex = tableView.indexPathForSelectedRow
      else { return }
    
    tableView.deselectRow(at: selectedIndex, animated: true)
  }
}

extension FamilyMembersViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyMemberCell")
      else { fatalError("Wrong cell identifier requested") }
    
    return cell
  }
}
