import UIKit
import Vision

class ViewController: UIViewController {

  @IBOutlet var imageView: UIImageView!
  @IBOutlet var objectDescription: UILabel!
  
  func analyzeImage(_ image: UIImage) {

    guard
      let cgImage = image.cgImage,
      let classifier = try? VNCoreMLModel(for: MobileNetV2().model)
    else { return }

    let request = VNCoreMLRequest(model: classifier, completionHandler: { [weak self] request, error in
      guard
        let classifications = request.results as? [VNClassificationObservation],
        let prediction = classifications.first
      else { return }

      DispatchQueue.main.async {
        self?.objectDescription.text = "\(prediction.identifier) (\(round(prediction.confidence * 100))% confidence)"
      }
    })

    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

    try? handler.perform([request])
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
