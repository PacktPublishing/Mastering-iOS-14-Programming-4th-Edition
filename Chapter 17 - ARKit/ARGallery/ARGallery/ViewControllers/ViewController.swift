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
    
    arKitScene.delegate = self
    arKitScene.session.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let imageSet = ARReferenceImage.referenceImages(inGroupNamed: "Art", bundle: Bundle.main)!
    
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = [.vertical, .horizontal]
    configuration.detectionImages = imageSet
    
    if let data = UserDefaults.standard.data(forKey: "ARGallery.worldmap"),
      let coder = try? NSKeyedUnarchiver(forReadingFrom: data) {
      
      coder.requiresSecureCoding = true
      configuration.initialWorldMap = ARWorldMap(coder: coder)
    }
    
    arKitScene.session.run(configuration, options: [])
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    arKitScene.session.pause()
  }
  
  func storeWorldMap() {
    arKitScene.session.getCurrentWorldMap { worldMap, error in
      guard let map = worldMap
        else { return }
      
      let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
      UserDefaults.standard.set(data, forKey: "ARGallery.worldmap")
    }
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
  func vizualise(_ node: SCNNode, for planeAnchor: ARPlaneAnchor) {
    let infoPlane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
    infoPlane.firstMaterial?.diffuse.contents = UIColor.orange
    infoPlane.firstMaterial?.transparency = 0.5
    infoPlane.cornerRadius = 0.2

    let infoNode = SCNNode(geometry: infoPlane)
    infoNode.eulerAngles.x = -.pi / 2

    node.addChildNode(infoNode)
  }
  
  func placeImageInfo(withNode node: SCNNode, for anchor: ARImageAnchor) {
    let referenceImage = anchor.referenceImage
    
    let infoPlane = SCNPlane(width: 15, height: 10)
    infoPlane.firstMaterial?.diffuse.contents = UIColor.white
    infoPlane.firstMaterial?.transparency = 0.5
    infoPlane.cornerRadius = 0.5
    
    let infoNode = SCNNode(geometry: infoPlane)
    infoNode.localTranslate(by: SCNVector3(0, 10, -referenceImage.physicalSize.height / 2 + 0.5))
    infoNode.eulerAngles.x = -.pi / 4
    
    let textGeometry = SCNText(string: artDescriptions[referenceImage.name ?? "flowers"], extrusionDepth: 0.2)
    textGeometry.firstMaterial?.diffuse.contents = UIColor.red
    textGeometry.font = UIFont.systemFont(ofSize: 1.3)
    textGeometry.isWrapped = true
    textGeometry.containerFrame = CGRect(x: -6.5, y: -4, width: 13, height: 8)
    
    let textNode = SCNNode(geometry: textGeometry)
    
    node.addChildNode(infoNode)
    infoNode.addChildNode(textNode)
  }
  
  func placeCustomImage(_ image: UIImage, withNode node: SCNNode) {
    let plane = SCNPlane(width: image.size.width / 1000, height: image.size.height / 1000)
    plane.firstMaterial?.diffuse.contents = image

    node.addChildNode(SCNNode(geometry: plane))
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    if let imageAnchor = anchor as? ARImageAnchor {
      placeImageInfo(withNode: node, for: imageAnchor)
    } else if let customImage = imageNodes[anchor.identifier] {
      placeCustomImage(customImage, withNode: node)
    } else if let planeAnchor = anchor as? ARPlaneAnchor {
      vizualise(node, for: planeAnchor)
    }
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let camera = arKitScene.session.currentFrame?.camera
      else { return }

    let hitTestResult = arKitScene.hitTest(CGPoint(x: 0.5, y: 0.5), types: [.existingPlane])
    let firstVerticalPlane = hitTestResult.first(where: { result in
      guard let planeAnchor = result.anchor as? ARPlaneAnchor
        else { return false }

      return planeAnchor.alignment == .vertical
    })

    var translation = matrix_identity_float4x4
    translation.columns.3.z = -Float(firstVerticalPlane?.distance ?? -1)
    let cameraTransform = camera.transform
    let rotation = matrix_float4x4(cameraAdjustmentMatrix)
    let transform = matrix_multiply(cameraTransform, matrix_multiply(translation, rotation))

    let anchor = ARAnchor(transform: transform)
    imageNodes[anchor.identifier] = UIImage(named: images[indexPath.row])!
    arKitScene.session.add(anchor: anchor)

    storeWorldMap()
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
