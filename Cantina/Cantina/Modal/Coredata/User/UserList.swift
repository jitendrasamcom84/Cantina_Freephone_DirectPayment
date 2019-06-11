import Foundation
import FastEasyMapping
import MagicalRecord

@objc(UserList)
open class UserList: _UserList {
    
    var itemLoadedBlock : ItemLoadedBlock = {_,_ in }
    	
    class func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: UserList.entityName())
        let dict: [String: String] = CDHelper.mapping(cls: UserList.self) as! [String : String]
        mapping.addAttributes(from: dict)
        mapping.addAttribute(UserList.dateTimeAttribute(for: "dateAdded", andKeyPath: "dateAdded"))
        mapping.primaryKey = "entity_id"
        return mapping
    }
    
    class func getAll() -> [UserList]? {
        return UserList.mr_findAllSorted(by: "dateAdded", ascending: false) as? [UserList]
    }
    
    class func createUser() -> UserList {
        if (UserList.mr_findFirst() == nil) {
            return UserList.newEntity()!
        }
        return UserList.mr_findFirst()!
    }
    
    class func newEntity() -> UserList? {
        let new = UserList.mr_createEntity(in: NSManagedObjectContext.mr_default())
        return new
    }
    
    class func saveUserList(){
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
    
    class func getbyFreeUserId(userId : String) -> UserList{
        return UserList.mr_findFirst(with: NSPredicate(format: "free_user_id ==%@", userId))!
    }
    
    class func getbyId(userId : String) -> UserList{
        return UserList.mr_findFirst(with: NSPredicate(format: "entity_id ==%@", userId))!
    }
    
    func delete() {
        self.mr_deleteEntity()
        UserList.saveUserList()
    }
    
    func delete(isDeposit : Bool, block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kDeleteUser)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                self.itemLoadedBlock("", "")
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        if isDeposit {
            let deposit: FreePhoneDeposit = FreePhoneDeposit.getFreePhoneDeposit()
            request.setParameter(self.main_free_user!, forKey: "main_free_user_id")
            request.setParameter(deposit.entity_id!, forKey: "deposit_id")
            request.startRequest()
        }
        else{
            request.setParameter(self.main_free_user!, forKey: "main_free_user_id")
            request.setParameter("", forKey: "deposit_id")
            request.startRequest()
        }
        
    }
    
    class func getbyUserId(userId : String) -> UserList{
        return UserList.mr_findFirst(with: NSPredicate(format: "user_id ==%@", userId))!
    }
    
    
    

}
