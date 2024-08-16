import UIKit
import CalendarKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = UIColor.white
    window?.makeKeyAndVisible()

      let storyboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
      let viewController = storyboard.instantiateInitialViewController() as! ProfileViewController
      let navigationController = UINavigationController(rootViewController: viewController)
      
    //  let storyboard = UIStoryboard(name: "CountersViewController", bundle: nil)
    //  let viewController = storyboard.instantiateInitialViewController() as! CountersViewController
    //  let navigationController = UINavigationController(rootViewController: viewController)
      
//    let dayViewController = CustomCalendarExampleController()
//    let navigationController = UINavigationController(rootViewController: dayViewController)
    window?.rootViewController = navigationController

    return true
  }
}
