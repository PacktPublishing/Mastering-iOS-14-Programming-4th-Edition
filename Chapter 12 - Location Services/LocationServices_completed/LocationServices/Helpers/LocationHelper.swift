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
    locationManager.delegate = self
    locationManager.allowsBackgroundLocationUpdates = true
  }
  
  func askPermission(_ completion: @escaping (CLAuthorizationStatus) -> Void) {
    let authorizationStatus = CLLocationManager.authorizationStatus()
    if authorizationStatus != .notDetermined {
      completion(authorizationStatus)
    } else {
      askPermissionCallback = completion
      locationManager.requestAlwaysAuthorization()
    }
  }
  
  func getLatestLocation(_ completion: @escaping (CLLocation) -> Void) {
    if let location = trackedLocations.last {
      completion(location)
    } else if CLLocationManager.locationServicesEnabled() {
      latestLocationObtainedCallback = completion
      locationManager.startUpdatingLocation()
    }
  }

  func getLocationName(for location: CLLocation, _ completion: @escaping (String) -> Void) {
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
    guard error == nil else {
      completion("An error ocurred: \(error?.localizedDescription ?? "Unknown error")")
      return
    }

    completion(placemarks?.first?.name ?? "Unkown location")
    }
  }

  func monitorSignificantChanges(_ locationHandler: @escaping (CLLocation) -> Void) {
    guard CLLocationManager.significantLocationChangeMonitoringAvailable() else { return }

    significantChangeReceivedCallback = locationHandler
    locationManager.startMonitoringSignificantLocationChanges()

    isTrackingSignificantLocationChanges = true
  }

  func setGeofence(at region: CLRegion, _ exitHandler: @escaping () -> Void, _ enterHandler: @escaping () -> Void) {
    guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else { return }
    geofenceExitCallback = exitHandler
    geofenceEnterCallback = enterHandler
    locationManager.startMonitoring(for: region)
  }
}

extension LocationHelper: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    askPermissionCallback?(status)
    askPermissionCallback = nil
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    latestLocationObtainedCallback?(locations.last!)
    latestLocationObtainedCallback = nil

    if isTrackingSignificantLocationChanges == false {
      locationManager.stopUpdatingLocation()
    }

    significantChangeReceivedCallback?(locations.last!)

    trackedLocations += locations
  }

  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    geofenceEnterCallback?()
  }

  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    geofenceExitCallback?()
  }
}
