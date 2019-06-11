import Foundation
import FastEasyMapping
import MagicalRecord

@objc(FreePhoneCommissionCalculation)
open class FreePhoneCommissionCalculation: _FreePhoneCommissionCalculation {
    
    class func defaultMapping () -> FEMMapping {
        let mapping = FEMMapping(entityName: FreePhoneCommissionCalculation.entityName())
        var dict: [String: String] = CDHelper.mapping(cls: FreePhoneCommissionCalculation.self) as! [String : String]
        dict.removeValue(forKey: "dateAdded");
        mapping.addAttributes(from: dict)
        mapping.addAttribute(FreePhoneCommissionCalculation.dateTimeAttribute(for: "dateAdded", andKeyPath: "dateAdded"))
        mapping.primaryKey = "entity_id"
        return mapping
    }
    
    class func getFirst() -> FreePhoneCommissionCalculation {
        return FreePhoneCommissionCalculation.mr_findFirst()!
    }
}
