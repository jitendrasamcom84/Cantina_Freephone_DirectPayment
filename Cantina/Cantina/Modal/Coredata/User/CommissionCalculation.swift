import Foundation
import FastEasyMapping
import MagicalRecord

@objc(CommissionCalculation)
open class CommissionCalculation: _CommissionCalculation {
	
    class func defaultMapping () -> FEMMapping {
        let mapping = FEMMapping(entityName: CommissionCalculation.entityName())
        var dict: [String: String] = CDHelper.mapping(cls: CommissionCalculation.self) as! [String : String]
        dict.removeValue(forKey: "dateAdded");
        mapping.addAttributes(from: dict)
        mapping.addAttribute(CommissionCalculation.dateTimeAttribute(for: "dateAdded", andKeyPath: "dateAdded"))
        mapping.primaryKey = "entity_id"
        return mapping
    }
    
    class func getFirst() -> CommissionCalculation {
        return CommissionCalculation.mr_findFirst()!
    }
}
