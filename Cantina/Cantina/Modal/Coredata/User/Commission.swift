import Foundation
import FastEasyMapping
import MagicalRecord

@objc(Commission)
open class Commission: _Commission {
	
    class func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: Commission.entityName())
        let dict: [String: String] = CDHelper.mapping(cls: Commission.self) as! [String : String]
        mapping.addAttributes(from: dict)
        return mapping
    }
    
    class func getCommissonAmount() -> Commission {
        return Commission.mr_findFirst()!
    }
}
