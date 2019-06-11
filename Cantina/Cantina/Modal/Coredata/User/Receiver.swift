import Foundation
import FastEasyMapping
import MagicalRecord

@objc(Receiver)
open class Receiver: _Receiver {
    var itemLoadedBlock : ItemLoadedBlock = {_,_ in }
    
    class func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: Receiver.entityName())
        var dict: [String: String] = CDHelper.mapping(cls: Receiver.self) as! [String : String]
        dict.removeValue(forKey: "dateAdded");
        mapping.addAttributes(from: dict)
        mapping.addAttribute(Receiver.dateTimeAttribute(for: "dateAdded", andKeyPath: "dateAdded"))
//        mapping.addRelationshipMapping(User.defaultMapping(), forProperty: "user_id", keyPath: "user_id")
        mapping.primaryKey = "entity_id"
        return mapping
    }
    
    class func createEntity() -> Receiver{
        let entity = mr_createEntity(in: NSManagedObjectContext.mr_default())
        return entity!
    }
    
    
    
    func saveEntity() {
        NSManagedObjectContext.mr_default().mr_saveToPersistentStore { (contectDidSave, error) in
            if(contectDidSave){
                print("saved")
            }else{
                print(error ?? "")
            }
        }
    }
    
    class func getAll() -> [Receiver] {
        var receiverArray = [Receiver]()
        let pre = NSPredicate(format: "is_deleted == false")
        //user_id.entity_id == %@   ,(AccountManager.instance().activeAccount?.userId)!
        receiverArray = Receiver.mr_findAllSorted(by: "dateAdded", ascending: true, with: pre) as! [Receiver]
        return receiverArray
    }
    
    class func getbyId(userId : String) -> Receiver{
        let pre = NSPredicate(format: "entity_id == %@", userId)
        if let reciever = Receiver.mr_findFirst(with: pre){
            return reciever
        }else{
            return Receiver.createEntity()
        }
        
    }
    
    //MARK: - Edit Contact API Call -
    
    func editContacts(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kEditContact)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                self.itemLoadedBlock(message as String,"")
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        
        request.setParameter(self.entity_id ?? "", forKey: "_id")
        request.setParameter(self.receiver_name ?? "", forKey: "receiver_name")
        request.setParameter(self.receiver_fname ?? "", forKey: "receiver_fname")
        request.setParameter(self.receiver_lname ?? "", forKey: "receiver_lname")
        request.setParameter(self.receiver_id ?? "", forKey: "receiver_id")
        request.setParameter(self.free_user_id ?? "", forKey: "free_user_id")
        request.setParameter(AccountManager.instance().activeAccount?.userId ?? "", forKey: "user_id")
        
        request.startRequest()
    }
    
    //MARK: - Add Contacts API Call -
    
    func addContacts(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kAddContact)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let data = request.serverData["receiversArr"] as? [String : Any] {
                    MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                        let obj = FEMDeserializer.object(fromRepresentation: data, mapping: Receiver.defaultMapping(), context: localContext)
                        block(obj,message as String)
                    })
                }
                
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        request.setParameter(AccountManager.instance().activeAccount?.userId ?? "", forKey: "user_id")
        request.setParameter(self.receiver_name ?? "", forKey: "receiver_name")
        request.setParameter(self.receiver_id ?? "", forKey: "receiver_id")
        request.setParameter(self.free_user_id ?? "", forKey: "free_user_id")
        request.startRequest()
    }
    
    //MARK: - Delete Contact API Call -
    
    func deleteContacts(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let url = "\(kDeleteContact)\(self.entity_id ?? "")"
        let request = Request.init(url: "\(kBaseUrl)\(url)", method: RequestMethod(rawValue: "DELETE")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                self.itemLoadedBlock(message as String,"")
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        request.startRequest()
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
            if self.main_free_user_id != nil{
                request.setParameter(self.main_free_user_id!, forKey: "main_free_user_id")
            }
            request.setParameter(deposit.entity_id!, forKey: "deposit_id")
            request.startRequest()
        }
        else{
            if self.main_free_user_id != nil{
                 request.setParameter(self.main_free_user_id!, forKey: "main_free_user_id")
            }
            request.setParameter("", forKey: "deposit_id")
            request.startRequest()
        }
        
    }
    
}
