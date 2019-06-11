import Foundation

@objc(TranzilaToken)
open class TranzilaToken: _TranzilaToken {
    
    class func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: TranzilaToken.entityName())
        var dict: [String: String] = CDHelper.mapping(cls: TranzilaToken.self) as! [String : String]
        dict.removeValue(forKey: "dateAdded");
        mapping.addAttributes(from: dict)
        mapping.addAttribute(TranzilaToken.dateTimeAttribute(for: "dateAdded", andKeyPath: "dateAdded"))
        mapping.primaryKey = "entity_id"
        return mapping
    }
    
    class func getAll() -> [TranzilaToken] {
        return TranzilaToken.mr_findAllSorted(by: "dateAdded", ascending: false) as! [TranzilaToken]
    }
}
