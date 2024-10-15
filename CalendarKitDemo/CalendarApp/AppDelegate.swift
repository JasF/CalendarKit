import UIKit
import CalendarKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      updateColorsTableIfNeeded()
      updateTransportsTableIfNeeded()
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = UIColor.white
    window?.makeKeyAndVisible()
      
      let storyboard = UIStoryboard(name: "JMSSettingsViewController", bundle: nil)
      let viewController = storyboard.instantiateInitialViewController() as! JMSSettingsViewController
      let navigationController = UINavigationController(rootViewController: viewController)
      /*
      let storyboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
      let viewController = storyboard.instantiateInitialViewController() as! ProfileViewController
      let navigationController = UINavigationController(rootViewController: viewController)
      */
    //  let storyboard = UIStoryboard(name: "CountersViewController", bundle: nil)
    //  let viewController = storyboard.instantiateInitialViewController() as! CountersViewController
    //  let navigationController = UINavigationController(rootViewController: viewController)
      
//    let dayViewController = CustomCalendarExampleController()
//    let navigationController = UINavigationController(rootViewController: dayViewController)
    window?.rootViewController = navigationController

    return true
  }
    
    func updateColorsTableIfNeeded() {
        let colors = JMSColor.mr_findAll() as! [JMSColor]
        if colors.count == 0 {
            var сolor = JMSColor.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSColor
            сolor.color = "#ff0000"
            сolor.uid = "1"
            сolor.name = "Красный"
            сolor = JMSColor.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSColor
            сolor.color = "#5bca49"
            сolor.uid = "2"
            сolor.name = "Зеленый"
            сolor = JMSColor.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSColor
            сolor.color = "#0066ff"
            сolor.uid = "3"
            сolor.name = "Синий"
            сolor = JMSColor.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSColor
            сolor.color = "#d5cc00"
            сolor.uid = "4"
            сolor.name = "Желтый"
            сolor = JMSColor.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSColor
            сolor.color = "#000000"
            сolor.uid = "5"
            сolor.name = "Черный"
            сolor = JMSColor.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSColor
            сolor.color = "#9c9c9c"
            сolor.uid = "6"
            сolor.name = "Серый"
            DSCoreData.shared().saveContext(completion: {})
        }
    }
    func updateTransportsTableIfNeeded() {
        let transports = JMSTransport.mr_findAll() as! [JMSTransport]
        if transports.count == 0 {
            var transport = JMSTransport.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSTransport
            transport.uid = "1"
            transport.name = "Автомобиль"
            transport = JMSTransport.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSTransport
            transport.uid = "2"
            transport.name = "Самолет"
            transport = JMSTransport.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSTransport
            transport.uid = "3"
            transport.name = "Поезд"
            transport = JMSTransport.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSTransport
            transport.uid = "4"
            transport.name = "Велосипед"
            transport = JMSTransport.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSTransport
            transport.uid = "5"
            transport.name = "Байк"
            transport = JMSTransport.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSTransport
            DSCoreData.shared().saveContext(completion: {})
            
        }
    }
}
