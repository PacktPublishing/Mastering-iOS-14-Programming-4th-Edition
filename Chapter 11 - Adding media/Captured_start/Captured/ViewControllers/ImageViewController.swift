import UIKit
import CoreImage

class ImageViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!
  
  var selectedImage: UIImage? {
    didSet {
      imageView.image = selectedImage
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func saveImage() {

  }
  
  @IBAction func applyGrayScale() {

  }
  
  @IBAction func cropSquare() {

  }
}
