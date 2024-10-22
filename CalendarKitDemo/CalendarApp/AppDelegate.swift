import UIKit
import CalendarKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      updateColorsTableIfNeeded()
      updateTransportsTableIfNeeded()
      updateServiceTableIfNeeded()
      updateClientsTableIfNeeded()
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
            DSCoreData.shared().saveContext(completion: {})
            
        }
    }
    func updateServiceTableIfNeeded() {
        let services = JMSService.mr_findAll() as! [JMSService]
        if services.count == 0 {
            var service = JMSService.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSService
            service.uid = "1"
            service.name = "Маникюр"
            service = JMSService.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSService
            service.uid = "2"
            service.name = "Педикюр"
            service = JMSService.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSService
            service.uid = "3"
            service.name = "Депиляция"
            service = JMSService.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSService
            service.uid = "4"
            service.name = "Бритье"
            service = JMSService.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSService
            service.uid = "5"
            service.name = "Стрижка"
            service = JMSService.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSService
            service.uid = "6"
            service.name = "Консультация"
            
        }
    }
    func updateClientsTableIfNeeded() {
        let clients = JMSClient.mr_findAll() as! [JMSClient]
        if clients.count == 0 {
            var client = JMSClient.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSClient
            client.id = "1"
            client.name = "Вика"
            client.surname = "Иванова"
            client.phone = "+3758001234567"
            client = JMSClient.mr_createEntity(in: DSCoreData.shared().readContext) as! JMSClient
            client.id = "2"
            client.name = "Тестовый"
            client.surname = "Клиент"
            client.phone = "+3758007777777"
        }
    }
}
