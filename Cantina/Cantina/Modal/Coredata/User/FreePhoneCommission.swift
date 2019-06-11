import Foundation
import FastEasyMapping
import MagicalRecord

@objc(FreePhoneCommission)
open class FreePhoneCommission: _FreePhoneCommission {
    
    class func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: FreePhoneCommission.entityName())
        let dict: [String: String] = CDHelper.mapping(cls: FreePhoneCommission.self) as! [String : String]
        mapping.addAttributes(from: dict)
        return mapping
    }
    
    class func getFreePhoneCommissionAmount() -> FreePhoneCommission {
        return FreePhoneCommission.mr_findFirst()!
    }
}
