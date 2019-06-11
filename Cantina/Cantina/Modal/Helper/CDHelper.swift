
import UIKit

class CDHelper: NSObject {
    
    class func mapping(cls:AnyClass) -> NSDictionary {
        let path = Bundle.main.path(forResource: "Mapping", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let keys: NSDictionary? = (dict?[NSStringFromClass(cls)] as! NSDictionary?)
        print(cls)
        return keys!;
    }
}
