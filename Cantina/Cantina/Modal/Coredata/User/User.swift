import Foundation

@objc(User)
open class User: _User {
    
    class func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: User.entityName())
        var dict: [String: String] = CDHelper.mapping(cls: User.self) as! [String : String]
        dict.removeValue(forKey: "date_add");
        dict.removeValue(forKey: "last_mod");
        mapping.addAttributes(from: dict)
        mapping.addAttribute(User.dateTimeAttribute(for: "date_add", andKeyPath: "date_add"))
        mapping.addAttribute(User.dateTimeAttribute(for: "last_mod", andKeyPath: "last_mod"))
        mapping.primaryKey = "entity_id"
        return mapping
    }
}
