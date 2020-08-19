import UIKit

class AddFamilyMemberViewController: UIViewController {
  
  @IBOutlet var familyNameField: UITextField!
  
  var delegate: AddFamilyMemberDelegate?
  
  @IBAction func cancelTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func saveTapped() {
    delegate?.saveFamilyMember(withName: familyNameField.text ?? "")
    dismiss(animated: true, completion: nil)
  }
}
