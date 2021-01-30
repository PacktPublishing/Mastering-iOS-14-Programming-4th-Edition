import UIKit
import ARKit

class ViewController: UIViewController {
  
  @IBOutlet var arKitScene: ARSCNView!
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var errorLabel: UILabel!
  @IBOutlet var errorView: UIView!
  
  let images: [String] = ["img_1", "img_2", "img_3", "img_4", "img_5"]
  var imageNodes = [UUID: UIImage]()

  let artDescriptions = ["bw_flowers": "Flowers in Black and White", "cactus": "A cactus", "text": "Enjoy the little things", "flowers": "Assorted flowers"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

extension ViewController: ARSessionDelegate {
  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    switch camera.trackingState {
    case .normal:
      errorView.isHidden = true
    case .notAvailable:
      
      errorLabel.text = "World tracking is not available right now"
    case let .limited(reason):
      errorView.isHidden = false
      switch reason {
        case .initializing:
        errorLabel.text = "The session is initializing"
        case .relocalizing:
        errorLabel.text = "The session is attempting to resume after an interruption"
        case .excessiveMotion:
        errorLabel.text = "The device is moving too much"
        case .insufficientFeatures:
        errorLabel.text = "Not enough features in the scene"
      @unknown default:
        fatalError()
      }
    }
  }
}

extension ViewController: ARSCNViewDelegate {

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

  }

  var cameraAdjustmentMatrix: SCNMatrix4 {
    switch UIDevice.current.orientation {
    case .portrait:
      return SCNMatrix4MakeRotation(.pi/2, 0, 0, 1)
    case .landscapeRight:
      return SCNMatrix4MakeRotation(.pi, 0, 0, 1)
    default:
      return SCNMatrix4MakeRotation(0, 0, 0, 0)
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionItem", for: indexPath)
    
    if let imageCell = cell as? GalleryCollectionItem {
      imageCell.imageView.image = UIImage(named: images[indexPath.row])!
    }
    
    return cell
  }
}
