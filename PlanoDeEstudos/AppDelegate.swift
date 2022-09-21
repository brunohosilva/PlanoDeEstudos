import UIKit


extension String {
    static let confirm = "Confirm"
    static let cancel = "Cancel"
    static let category = "Lembrete"
    static let confirmed = "Confirmed"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        center.delegate = self
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.center.requestAuthorization(options: [.sound, .alert, .badge, .carPlay]) { authorized, error in
                    print("o usuario autorizou? --->?", authorized)
                }
            default:
                print("default")
            
            }
        }
        
        
        let confirmAction = UNNotificationAction(identifier: .confirm,
                                                 title: "Já estudei 🫡",
                                                 options: [.foreground])
        
        let cancelAction = UNNotificationAction(identifier: .cancel,
                                                title: "Cancelar",
                                                options: [])
        
        let category = UNNotificationCategory(identifier: .category,
                                              actions: [confirmAction, cancelAction],
                                              intentIdentifiers: [])
        
        center.setNotificationCategories([category])
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("O app foi resgistrado para receber push")
        let token = deviceToken.reduce("") {$0 + String(format: "%02x", $1)}
        print("Aqui está o token --->", token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Errrouuuuu", error)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
//        let title = response.notification.request.content.title
        
        switch response.actionIdentifier {
        case .confirm:
            print("Usuario apertou em confirmar")
            let id = response.notification.request.identifier
           
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: .confirmed),
                                            object: nil,
                                            userInfo: ["id": id])
            
        case.cancel :
            print("Usuario apertou em cancelar")
        case UNNotificationDismissActionIdentifier:
            print("Usuario dissmiss notificaçao")
        default:
            print("Bla")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner])
    }
}
