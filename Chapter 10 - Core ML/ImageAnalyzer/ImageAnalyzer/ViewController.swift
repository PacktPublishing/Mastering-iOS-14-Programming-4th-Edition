import UIKit

class ViewController: UIViewController {

  @IBOutlet var imageView: UIImageView!
  @IBOutlet var objectDescription: UILabel!
  
  func analyzeImage(_ image: UIImage) {
    
  }

  @IBAction func selectImage() {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .photoLibrary
    present(imagePicker, animated: true, completion: nil)
  }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
      else { return }
    
    imageView.image = image
    picker.dismiss(animated: true, completion: nil)
    analyzeImage(image)
  }
}
