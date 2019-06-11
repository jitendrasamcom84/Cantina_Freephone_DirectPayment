import Foundation
import FastEasyMapping
import MagicalRecord

@objc(FreePhoneDeposit)
open class FreePhoneDeposit: _FreePhoneDeposit {
    
    class func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: FreePhoneDeposit.entityName())
        let dict: [String: String] = CDHelper.mapping(cls: FreePhoneDeposit.self) as! [String : String]
        
        mapping.addAttributes(from: dict)
//        mapping.addAttribute(FreePhoneDeposit.dateTimeAttribute(for: "updated_date", andKeyPath: "updated_date"))
        mapping.addAttribute(FreePhoneDeposit.dateTimeAttribute(for: "dateAdded", andKeyPath: "dateAdded"))
        mapping.primaryKey = "entity_id"
        return mapping
    }
    
    class func getFreePhoneDeposit() -> FreePhoneDeposit {
        if (FreePhoneDeposit.mr_findFirst() == nil) {
            return FreePhoneDeposit.newEntity()!
        }
        return FreePhoneDeposit.mr_findFirst()!
    }
    
    class func newEntity() -> FreePhoneDeposit? {
        let new = FreePhoneDeposit.mr_createEntity(in: NSManagedObjectContext.mr_default())
        return new
    }
    
    class func saveFreePhoneDeposit(){
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
    
    class func getbyId(pId : String) -> FreePhoneDeposit{
        return FreePhoneDeposit.mr_findFirst(with: NSPredicate(format: "entity_id ==%@", pId))!
    }
    
    class func getbyRecId(rId : String) -> FreePhoneDeposit{
        return FreePhoneDeposit.mr_findFirst(with: NSPredicate(format: "rec_id ==%@", rId))!
    }
}

