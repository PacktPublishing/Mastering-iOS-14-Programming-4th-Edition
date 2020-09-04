import CoreLocation

class LocationHelper: NSObject {
  let locationManager = CLLocationManager()
  
  private var askPermissionCallback: ((CLAuthorizationStatus) -> Void)?
  private var latestLocationObtainedCallback: ((CLLocation) -> Void)?
  private var geofenceEnterCallback: (() -> Void)?
  private var geofenceExitCallback: (() -> Void)?
  private var significantChangeReceivedCallback: ((CLLocation) -> Void)?
  
  var trackedLocations = [CLLocation]()
  var isTrackingSignificantLocationChanges = false
  
  override init() {
    super.init()
  }
  
  func askPermission(_ completion: @escaping (CLAuthorizationStatus) -> Void) {
  }
  
  func getLatestLocation(_ completion: @escaping (CLLocation) -> Void) {

  }
  
  func getLocationName(for location: CLLocation, _ completion: @escaping (String) -> Void) {
    
  }
  
  func setGeofence(at region: CLRegion, _ exitHandler: @escaping () -> Void, _ enterHandler: @escaping () -> Void) {
    
  }
  
  func monitorSignificantChanges(_ locationHandler: @escaping (CLLocation) -> Void) {
    
  }
}

extension LocationHelper: CLLocationManagerDelegate {
  
}
