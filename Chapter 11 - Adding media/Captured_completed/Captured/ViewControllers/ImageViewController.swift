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
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .camera
    imagePicker.delegate = self
    present(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func saveImage() {
    guard let image = selectedImage else { return }
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(didSaveImage(_:withError:contextInfo:)), nil)
  }

  @objc func didSaveImage(_ image: UIImage, withError error: Error?, contextInfo: UnsafeRawPointer) {
    guard error == nil else { return }
    presentAlertWithTitle("Success", message: "Image was saved succesfully")
  }
  
  @IBAction func applyGrayScale() {
    // 1
    guard let cgImage = selectedImage?.cgImage,
    // 2
    let initialOrientation = selectedImage?.imageOrientation,
    // 3
    let filter = CIFilter(name: "CIPhotoEffectNoir") else { return }

    // 4
    let sourceImage = CIImage(cgImage: cgImage)
    filter.setValue(sourceImage, forKey: kCIInputImageKey)

    // 5
    let context = CIContext(options: nil)
    guard let outputImage = filter.outputImage, let cgImageOut = context.createCGImage(outputImage, from: outputImage.extent) else { return }

    // 6
    selectedImage = UIImage(cgImage: cgImageOut, scale: 1, orientation: initialOrientation)
  }
  
  @IBAction func cropSquare() {
    let context = CIContext(options: nil)

    guard let cgImage = selectedImage?.cgImage, let initialOrientation = selectedImage?.imageOrientation, let filter = CIFilter(name: "CICrop") else { return }

    let size = CGFloat(min(cgImage.width, cgImage.height))
    let center = CGPoint(x: cgImage.width / 2, y: cgImage.height / 2)
    let origin = CGPoint(x: center.x - size / 2, y: center.y - size / 2)
    let cropRect = CGRect(origin: origin, size: CGSize(width: size, height: size))

    let sourceImage = CIImage(cgImage: cgImage)
    filter.setValue(sourceImage, forKey: kCIInputImageKey)
    filter.setValue(CIVector(cgRect: cropRect), forKey: "inputRectangle")

    guard let outputImage = filter.outputImage, let cgImageOut = context.createCGImage(outputImage, from: outputImage.extent) else { return }

    selectedImage = UIImage(cgImage: cgImageOut, scale: 1, orientation: initialOrientation)
  }
}

extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true, completion: nil)
    guard let image = info[.originalImage] as? UIImage else { return }
    selectedImage = image
  }
}

