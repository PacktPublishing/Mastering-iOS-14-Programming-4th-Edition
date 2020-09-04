import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let locationHelper = LocationHelper()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    if let tabBarController = window?.rootViewController as? UITabBarController,
      let viewControllers = tabBarController.viewControllers {

      for viewController in viewControllers {
        if var locationRequiring = viewController as? LocationHelperRequiring {
          locationRequiring.locationHelper = locationHelper
        }
      }
    }
    
    return true
  }
}

