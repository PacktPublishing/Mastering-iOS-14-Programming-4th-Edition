import UIKit
import CoreLocation
import MapKit

class GeofenceViewController: UIViewController, LocationHelperRequiring {
  var locationHelper: LocationHelper!
  
  @IBOutlet var locationNameLabel: UILabel!
  @IBOutlet var locationCoordinatesLabel: UILabel!
  @IBOutlet var geofenceStatusLabel: UILabel!
  @IBOutlet var mapView: MKMapView!
  
  var currentLocation: CLLocation?
  var geofenceOverlay: MKCircle?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  func showCurrentLocation() {
    locationHelper.getLatestLocation { [weak self] location in
      self?.locationCoordinatesLabel.text = "\(location.coordinate.latitude) / \(location.coordinate.longitude)"
      self?.currentLocation = location
      
      self?.locationHelper.getLocationName(for: location) { locationName in
        self?.locationNameLabel.text = locationName
      }
      
      if let mapView = self?.mapView {
        let visibleRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(mapView.regionThatFits(visibleRegion), animated: true)
      }
    }
  }
  
  @IBAction func setGeofence() {
    guard let location = currentLocation
      else { return }
    
    let enterHandler: () -> Void = { [weak self] in
      self?.geofenceStatusLabel.text = "You have entered the geofence"
    }
    
    let exitHandler: () -> Void = { [weak self] in
      self?.geofenceStatusLabel.text = "You have exitted the geofence"
    }
    
    if let currentOverlay = geofenceOverlay {
      mapView.removeOverlay(currentOverlay)
    }
    
    geofenceOverlay = MKCircle(center: location.coordinate, radius: 30)
    mapView.addOverlay(geofenceOverlay!)
    geofenceStatusLabel.text = "Awaiting geofence event"
  }
}

extension GeofenceViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let circleRenderer = MKCircleRenderer(overlay: overlay)
    circleRenderer.strokeColor = UIColor.orange
    circleRenderer.lineWidth = 3
    circleRenderer.fillColor = UIColor.orange.withAlphaComponent(0.8)
    return circleRenderer
  }
}
