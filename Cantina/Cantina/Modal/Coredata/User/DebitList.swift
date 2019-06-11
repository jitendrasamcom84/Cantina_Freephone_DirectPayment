import Foundation
import FastEasyMapping
import MagicalRecord

@objc(DebitList)
open class DebitList: _DebitList {
    var itemLoadedBlock : ItemLoadedBlock = {_,_ in }
    var itemSavedBlock : ItemSavedBlock = {_,_ in }
    
    class func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: DebitList.entityName())
        var dict: [String: String] = CDHelper.mapping(cls: DebitList.self) as! [String : String]
        dict.removeValue(forKey: "dateAdded");
        mapping.addAttributes(from: dict)
        mapping.addAttribute(DebitList.dateTimeAttribute(for: "dateAdded", andKeyPath: "dateAdded"))
        mapping.addRelationshipMapping(User.defaultMapping(), forProperty: "user_id", keyPath: "user_id")
        mapping.primaryKey = "entity_id"
        return mapping
    }
    
    class func getAll() -> [DebitList] {
        let pre = NSPredicate(format: "is_deleted == false && user_id.entity_id == %@",(AccountManager.instance().activeAccount?.userId)!)
        return DebitList.mr_findAllSorted(by: "dateAdded", ascending: true, with: pre) as! [DebitList]
    }
    class func getbyId(id : String) -> DebitList{
        return DebitList.mr_findFirst(with: NSPredicate(format: "entity_id ==%@", id))!
    }
    class func createEntity() -> DebitList{
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
    
    func addDebit(block : @escaping ItemSavedBlock) {
        itemSavedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kAddDebitList)", method: RequestMethod(rawValue: "PUT")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if(request.isSuccess){
                    if let dataDict = request.serverData["data"] as? [String : Any] {
                        if let debitId = dataDict["id"]{
                            self.itemSavedBlock(debitId,"")
                        }
                    }
                } else {
                    self.itemSavedBlock("",message as String)
                }
                
            } else {
                self.itemSavedBlock("",message as String)
            }
        }
        request.setParameter(AccountManager.instance().activeAccount?.userId ?? "", forKey: "user_id")
        request.setParameter(self.receiver_name ?? "", forKey: "receiver_name")
        request.setParameter(self.receiver_id ?? "", forKey: "receiver_id")
        request.setParameter(self.amount ?? "", forKey: "amount")
        request.setParameter(self.date ?? "", forKey: "date")
        request.setParameter(self.payment_type ?? "", forKey: "payment_type")
        request.setParameter(self.commission ?? "", forKey: "commission")
        request.setParameter(self.total_amount ?? "", forKey: "total_amount")
        request.startRequest()
        /*
         {
         "user_id":"5aa11630a4108c3ca101ece4",
         "receiver_id":"abc123",
         "date":"31",
         "receiver_name" : "ABCD ABCD",
         "payment_type" : 1,
         "amount":10.00,
         "commission": "5",
         "total_amount": "15"
         }
 */
    }
    
    func editdebitList(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let url = "\(kEditDebitList)\(self.entity_id ?? "")"
        let request = Request.init(url: "\(kBaseUrl)\(url)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                self.itemLoadedBlock(message as String,"")
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        request.setParameter(AccountManager.instance().activeAccount?.userId ?? "", forKey: "user_id")
        request.setParameter(self.receiver_name ?? "", forKey: "receiver_name")
        request.setParameter(self.receiver_id ?? "", forKey: "receiver_id")
        request.setParameter(self.amount ?? "", forKey: "amount")
        request.setParameter(self.date ?? "", forKey: "date")
        request.setParameter(self.payment_type ?? "", forKey: "payment_type")
        request.startRequest()
    }
    
    func deleteDebitById(block : @escaping ItemSavedBlock){
        itemSavedBlock = block
        let url = "\(kDeleteDebit)\(self.entity_id ?? "")"
        let request = Request.init(url: "\(kBaseUrl)\(url)", method: RequestMethod(rawValue: "DELETE")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                self.itemSavedBlock("",message as String)
            } else {
                self.itemSavedBlock("",message as String)
            }
        }
        request.startRequest()
    }
}
