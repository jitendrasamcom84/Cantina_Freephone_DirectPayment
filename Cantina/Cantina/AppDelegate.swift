
import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import CoreData
import Reachability
import MagicalRecord
import AlamofireNetworkActivityLogger
import IQKeyboardManager
import AppVersionMonitor

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    var navigationController = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("sratrt")
        sleep(2)
        UIApplication.shared.statusBarStyle = .lightContent
//       self.connectToFcm()
        self.registerFCM()

        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
        setupCoredata()
        print("end")
              
        IQKeyboardManager.shared().isEnabled = true
        
//        self.perform(#selector(checkAppUpdateVersion), with: nil, afterDelay: 5.0)
        return true
    }
    
    class func sharedInstance() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func registerFCM()  {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        let fcmToken = InstanceID.instanceID().token()
        if(fcmToken != nil){
            Utils.setStringForKey(fcmToken!, key: kFCMToken)
            UIApplication.shared.registerForRemoteNotifications()
        }else{
            Utils.setStringForKey("bbbb", key: kFCMToken)
        }
    }
    
    func connectToFcm() {
        Messaging.messaging().connect { (error) in
        }
    }
    
    func clearDatabase(){
        MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
            DebitList.mr_truncateAll(in: localContext);
            Payment.mr_truncateAll(in: localContext);
            Receiver.mr_truncateAll(in: localContext);
            User.mr_truncateAll(in: localContext);
            FreePhoneDeposit.mr_truncateAll(in: localContext);
            UserList.mr_truncateAll(in: localContext);
            TranzilaToken.mr_truncateAll(in: localContext);
        })
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        Utils.setStringForKey(fcmToken, key: kFCMToken)
    }
    
//    @objc func checkAppUpdateVersion() {
//        AppVersionMonitor.sharedMonitor.startup()
//        let versionString: String = AppVersion.marketingVersion.versionString // "1.2.3"
//        Manager.sharedManager().checkUpdateVersion { (version_number, message) -> (Void) in
//            let v_n : String = version_number as! String
//            print(versionString)//v_n
//            if  v_n != versionString{
//                //
//                let alertController = UIAlertController(title: ALERT_TITLE, message: "אופס הגרסה שלך לא עדכנית יש לעדכן גרסה בחנות" , preferredStyle: .alert)
//                let actionOk = UIAlertAction(title: "עדכון", style: .default, handler: { (action) in
//                    let url : URL = URL.init(string:"https://itunes.apple.com/us/app/%D7%A7%D7%A0%D7%98%D7%99%D7%A0%D7%94-%D7%93%D7%99%D7%92%D7%99%D7%98%D7%9C/id1387397581?ls=1&mt=8")!
//                    if UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                        //If you want handle the completion block than
//                        UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
//                            print("Open url : \(success)")
//                        })
//                    }
//                })
//                alertController.addAction(actionOk)
//                Utils.getTopViewController().present(alertController, animated: true)
//            }
//        }
//    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        
        //InstanceID.instanceID().setAPNSToken(deviceToken, type: .prod)
        let fcmToken = InstanceID.instanceID().token()
        if (fcmToken != nil) {
            Utils.setStringForKey(fcmToken!, key: kFCMToken)
            if AccountManager.instance().activeAccount != nil{
                registerToken()
            }
        } else {
            let delayInSeconds: Double = 30.0
            let when = DispatchTime.now() + delayInSeconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.getTokenAfterDelay()
            }
        }
        connectToFcm()
    }
    
    func getTokenAfterDelay() {
        let refreshedToken = InstanceID.instanceID().token()
        if refreshedToken != "" {
            Utils.setStringForKey(refreshedToken!, key: kFCMToken)
            if (AccountManager.instance().activeAccount != nil) {
                registerToken()
            }
        } else {
            let delayInSeconds: Double = 30.0
            let when = DispatchTime.now() + delayInSeconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.getTokenAfterDelay()
            }
        }
    }
    
    func registerToken() {
        let acc: Account? = AccountManager.instance().activeAccount
        if(Utils.fetchString(forKey: kFCMToken) == ""){
            acc?.token = "simulator"
        }
        else {
            if !(acc?.token == Utils.fetchString(forKey: kFCMToken)) {
                acc?.token = Utils.fetchString(forKey: kFCMToken)
            }
        }
    }
    
    func setupCoredata(){
        MagicalRecord.setupCoreDataStack(withAutoMigratingSqliteStoreNamed: "Cantina.sqlite")
        let paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print("path  = \(paths)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func isReachable() -> Bool {
        let reachability = Reachability()!
        switch reachability.connection {
        case .wifi:
            return true;
        case .cellular:
            return true;
        case .none:
            return false;
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //Siren.shared.checkVersion(checkType: .immediately)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
       // Siren.shared.checkVersion(checkType: .daily)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Cantina")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        } else {            
        }
    }
}

