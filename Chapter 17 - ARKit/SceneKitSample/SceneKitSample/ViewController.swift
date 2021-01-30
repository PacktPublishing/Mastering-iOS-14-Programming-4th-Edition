import UIKit
import SceneKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let sceneView = self.view as? SCNView
      else { return }
    
    let scene = SCNScene()
    sceneView.scene = scene
    sceneView.allowsCameraControl = true
    sceneView.showsStatistics = true
    sceneView.backgroundColor = UIColor.black
    
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
    scene.rootNode.addChildNode(cameraNode)
    
    let ambientLightNode = SCNNode()
    ambientLightNode.light = SCNLight()
    ambientLightNode.light!.type = .ambient
    ambientLightNode.light!.color = UIColor.orange
    scene.rootNode.addChildNode(ambientLightNode)
    
    let plane = SCNPlane(width: 15, height: 10)
    plane.firstMaterial?.diffuse.contents = UIColor.white
    plane.firstMaterial?.isDoubleSided = true
    plane.cornerRadius = 0.3

    let planeNode = SCNNode(geometry: plane)
    planeNode.position = SCNVector3(x: 0, y: 0, z: -15)
    scene.rootNode.addChildNode(planeNode)
    
    let text = SCNText(string: "Hello, world!", extrusionDepth: 0)
    text.font = UIFont.systemFont(ofSize: 2.3)
    text.isWrapped = true
    text.containerFrame = CGRect(x: -6.5, y: -4, width: 13, height: 8)
    text.firstMaterial?.diffuse.contents = UIColor.red

    let textNode = SCNNode(geometry: text)
    planeNode.addChildNode(textNode)
  }
}

