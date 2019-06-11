
import UIKit

class UDClass: NSObject {
    
    class func fetchString(forKey key: String) -> String {
        if let aStr = UserDefaults.standard.string(forKey: key) {
            return aStr
        } else {
            return ""
        }
    }
    
    class func setString(_ value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func setBoolForKey(_ value: Bool, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func fetchBool(forKey key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    class func deleteKeyInUserDefault(key:String) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
    }
}
