import Foundation
import FastEasyMapping
import MagicalRecord

@objc(Payment)
open class Payment: _Payment {
    
    class func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: Payment.entityName())
        var dict: [String: String] = CDHelper.mapping(cls: Payment.self) as! [String : String]
        dict.removeValue(forKey: "dateAdded");
        dict.removeValue(forKey: "payment_type");
        mapping.addAttributes(from: dict)
        mapping.addAttribute(Payment.dateTimeAttribute(for: "dateAdded", andKeyPath: "dateAdded"))
        mapping.addAttribute(Payment.stringAttribute(for: "payment_type", andKeyPath: "payment_type"))
        mapping.addRelationshipMapping(User.defaultMapping(), forProperty: "user_id", keyPath: "user_id")
        mapping.addRelationshipMapping(Receiver.defaultMapping(), forProperty: "rec_id", keyPath: "rec_id")
        mapping.primaryKey = "entity_id"
        return mapping
    }
    
    class func getAll() -> [Payment] {
//        return Payment.mr_findAllSorted(by: "dateAdded", ascending: false, with: NSPredicate(format: "status == 1")) as! [Payment]
        return Payment.mr_findAllSorted(by: "dateAdded", ascending: false) as! [Payment]
    }
    
    class func getbyId(pId : String) -> Payment{
        return Payment.mr_findFirst(with: NSPredicate(format: "entity_id ==%@", pId))!
    }    
}
