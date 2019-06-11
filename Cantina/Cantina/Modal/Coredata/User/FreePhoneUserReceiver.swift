import Foundation

@objc(FreePhoneUserReceiver)
open class FreePhoneUserReceiver: _FreePhoneUserReceiver {
    class func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: FreePhoneUserReceiver.entityName())
        var dict: [String: String] = CDHelper.mapping(cls: FreePhoneUserReceiver.self) as! [String : String]
        dict.removeValue(forKey: "dateAdded");
        mapping.addAttributes(from: dict)
        mapping.addAttribute(FreePhoneUserReceiver.dateTimeAttribute(for: "dateAdded", andKeyPath: "dateAdded"))
        
        mapping.primaryKey = "entity_id"
        return mapping
    }
}
