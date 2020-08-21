import UIKit
import Vision

class ViewController: UIViewController {
  
  @IBOutlet var textView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textView.layer.cornerRadius = 6
    textView.layer.borderColor = UIColor.lightGray.cgColor
    textView.layer.borderWidth = 1
  }
  
  @IBAction func analyze() {
    
  }
}
