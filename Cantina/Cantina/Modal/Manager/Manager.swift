import UIKit
import MagicalRecord
import FastEasyMapping

class Manager: NSObject {
    var itemLoadedBlock : ItemLoadedBlock = {_,_ in }
    
    class func sharedManager() -> Manager {
        var singleton: Manager? = nil
        if singleton == nil {
            singleton = Manager()
        }
        return singleton!
    }
    
    func checkUpdateVersion(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kGetUpdateVersion)", method: RequestMethod(rawValue: "GET")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataDict = request.serverData["data"] as? [String : Any] {
                    if let version_number = dataDict["ios_app_version"] as? String{
                        
                        self.itemLoadedBlock(version_number,"")
                    }
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        //{"data":{"android_app_version":"1.0.0","ios_app_version":"1.0.0"},"is_error":false,"message":""}
        request.startRequest()
    }
    
    func addPayment(totalAmount:String, amount:String, receivername:String, receiverId:String, block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kAddPayment)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataDict = request.serverData["data"] as? [String : Any] {
                    print(dataDict)
                    if let paymentId = dataDict["id"] as? String{
                        
                        self.itemLoadedBlock(paymentId,"")
                    }
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        
        let account : Account = AccountManager.instance().activeAccount!
        request.setParameter(account.userId, forKey: "user_id")
        request.setParameter(receiverId, forKey: "receiver_id")
        request.setParameter(amount, forKey: "amount")
        request.setParameter(receivername, forKey: "receiver_name")
        request.setParameter(totalAmount, forKey: "total_amount")
        request.startRequest()
    }
    
    
    func loadTranzilaToken(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kTranzilaToken)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataArray = request.serverData["data"] as? [[String : Any]] {
                    MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                        
                        let arr = FEMDeserializer.collection(fromRepresentation: dataArray, mapping: TranzilaToken.defaultMapping(), context: localContext)
                        DispatchQueue.main.async {
                            self.itemLoadedBlock(arr,"")
                        }
                    })
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        let dict = ["user":AccountManager.instance().activeAccount?.userId ?? "","is_Active":"1"]
        request.setParameter(dict, forKey: "where")
        request.startRequest()
    }
    
    func loadTranzilaTokenForDebit(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kTranzilaToken)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataArray = request.serverData["data"] as? [[String : Any]] {
                    MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                        let arr = FEMDeserializer.collection(fromRepresentation: dataArray, mapping: TranzilaToken.defaultMapping(), context: localContext)
                        DispatchQueue.main.async {
                            self.itemLoadedBlock(arr,"")
                        }
                    })
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        let dict = ["user":AccountManager.instance().activeAccount?.userId ?? "","is_Active":"1"]
        request.setParameter(dict, forKey: "where")
        request.startRequest()
    }
    
    
    func sendDebitPaymentTranzilaToken(paymentId:String , token:String , expDate : String, block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kSendDebitApi)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                self.itemLoadedBlock("","")
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        request.setParameter(paymentId, forKey: "debit_id")
        request.setParameter(token, forKey: "token")
        request.setParameter(expDate, forKey: "expdate")
        request.setParameter("0", forKey: "is_save_card")
        request.setParameter(Utils.fetchString(forKey: kPaymentType), forKey: "payment_type")
        request.startRequest()
    }
    
    func sendPaymentTranzilaToken(paymentId:String , token:String , expDate : String, block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kSendPaymentApi)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                self.itemLoadedBlock("","")
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        request.setParameter(paymentId, forKey: "payment_id")
        request.setParameter(token, forKey: "token")
        request.setParameter(expDate, forKey: "expdate")
        request.setParameter(Utils.fetchString(forKey: kPaymentType), forKey: "payment_type")
        request.setParameter("0", forKey: "is_save_card")
        request.startRequest()
    }
    
    func sendDebitPayment(paymentId:String,is_save_card:String,block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kSendDebitApi)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataDict = request.serverData["data"] as? [String : Any] {
                    print(dataDict)
                    if let requestDict = dataDict["request"]  as? [String : Any]{
                        print(requestDict)
                        if let uriDict = requestDict["uri"]  as? [String : Any]{
                            print(uriDict)
                            if let aStrId = uriDict["redirect_url"] as? String{
                                self.itemLoadedBlock(aStrId,"")
                            }
                        }
                    }
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        request.setParameter(paymentId, forKey: "debit_id")
        request.setParameter("", forKey: "token")
        request.setParameter("", forKey: "expdate")
        request.setParameter(is_save_card, forKey: "is_save_card")
        request.setParameter(Utils.fetchString(forKey: kPaymentType), forKey: "payment_type")
        request.startRequest()
    }
    
    func sendPayment(paymentId:String,is_save_card:String, block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kSendPaymentApi)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataDict = request.serverData["data"] as? [String : Any] {
                    print(dataDict)
                    if let requestDict = dataDict["request"]  as? [String : Any]{
                        print(requestDict)
                        if let uriDict = requestDict["uri"]  as? [String : Any]{
                            print(uriDict)
                            if let aStrId = uriDict["redirect_url"] as? String{
                                self.itemLoadedBlock(aStrId,"")
                            }
                        }
                    }
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        request.setParameter(paymentId, forKey: "payment_id")
        request.setParameter("", forKey: "token")
        request.setParameter(is_save_card, forKey: "is_save_card")
        request.setParameter("", forKey: "expdate")
        request.setParameter(Utils.fetchString(forKey: kPaymentType), forKey: "payment_type")
        request.startRequest()
    }
    
    func loadPaymenthistory(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kGetPaymentHistory)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataArray = request.serverData["data"] as? [[String : Any]] {
                    MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                        let arr = FEMDeserializer.collection(fromRepresentation: dataArray, mapping: Payment.defaultMapping(), context: localContext)
                        DispatchQueue.main.async {
                            self.itemLoadedBlock(arr,"")
                        }
                    })
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }        
        let whereDict : NSMutableDictionary = ["user_id":AccountManager.instance().activeAccount?.userId ?? "",  "is_pay" : "1"]
        request.setParameter(whereDict, forKey: "where")
        request.startRequest()
    }
    
    func loadPaymenthistoryNewAPI(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kGetPaymentHistoryNewAPI)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataArray = request.serverData["data"] as? [[String : Any]] {
                    MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                        let arr = FEMDeserializer.collection(fromRepresentation: dataArray, mapping: Payment.defaultMapping(), context: localContext)
                        block(arr,"")
                    })
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        
        request.setParameter(AccountManager.instance().activeAccount?.userId ?? "", forKey: "user_id")
        request.startRequest()
    }
    
    func loadQuestionAnswer(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kQA)", method: RequestMethod(rawValue: "GET")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataArray = request.serverData["data"] as? [[String : Any]] {
                    MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                        let arr = FEMDeserializer.collection(fromRepresentation: dataArray, mapping: QuestionAnswer.defaultMapping(), context: localContext)
                        DispatchQueue.main.async {
                            self.itemLoadedBlock(arr,"")
                        }
                    })
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        request.startRequest()
    }
    
    func loadMyContacts(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kGetContactList)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataArray = request.serverData["data"] as? [[String : Any]] {
                    MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                        Receiver.mr_truncateAll(in: localContext)
                        let arr = FEMDeserializer.collection(fromRepresentation: dataArray, mapping: Receiver.defaultMapping(), context: localContext)
                        DispatchQueue.main.async {
                            block(arr,"")
                        }
                    })
                } else {
                    block("",message as String)
                }
            } else {
                block("",message as String)
            }
        }
        
        request.setParameter(AccountManager.instance().activeAccount?.userId ?? "", forKey: "user")
        request.startRequest()
    }
    
    func loadDebitList(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kGetUserDebitList)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataArray = request.serverData["data"] as? [[String : Any]] {
                    MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                        let arr = FEMDeserializer.collection(fromRepresentation: dataArray, mapping: DebitList.defaultMapping(), context: localContext)
                        DispatchQueue.main.async {
                            self.itemLoadedBlock(arr,"")
                        }
                    })
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        request.setParameter(AccountManager.instance().activeAccount?.userId ?? "", forKey: "user_id")
        request.startRequest()
    }
    
    func loadCommission(amount:String, block : @escaping ItemLoadedBlock){
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kGetCommission)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataDict = request.serverData["data"] as? [String : Any] {                    
                    DispatchQueue.main.async {
                        let total_amount  = dataDict["total_amount"]!
                        self.itemLoadedBlock(total_amount, "")
                        
                    }
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        let commissionAmount  = amount.replacingOccurrences(of: "₪", with: "")
        request.setParameter(commissionAmount, forKey: "amount")
        request.startRequest()
    }
    
    func loadCalculationCommission(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(KGetCommissionCalculation)", method: RequestMethod(rawValue: "GET")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataArray = request.serverData["data"] as? [[String : Any]] {
                    MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                        let arr = FEMDeserializer.collection(fromRepresentation: dataArray, mapping: CommissionCalculation.defaultMapping(), context: localContext)
                        DispatchQueue.main.async {
                            self.itemLoadedBlock(arr,"")
                        }
                    })
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        request.startRequest()
    }
    
    /*
     please set save card api parameter
     {
     "id":"5b34b5bc9ce5ea57cd3f5ded",
     "user_id":"5b29f868a1c85a5d7495c848",
     "pay_type": "1"
     }
     
     pay_type =1 -> payment_id pass in id
     pay_type =2 -> debit_id pass in id
     */
    func saveCard(paymentId:String,pay_type:String, block : @escaping ItemLoadedBlock){
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kSave_card)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                self.itemLoadedBlock("", "")
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        
        request.setParameter(paymentId, forKey: "id")
        request.setParameter(AccountManager.instance().activeAccount?.userId ?? "", forKey: "user_id")
        request.setParameter(pay_type, forKey: "pay_type")
        request.startRequest()
    }
    
    
    //MARK: FreePhone Api
    func loadUserList(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kGetCantinaANDFreephoneReceiverList)", method: RequestMethod(rawValue: "GET")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                
                if let dataArray = request.serverData["data"] as? [[String : Any]] {
                    //                    var arr = [[String : Any]] ()
                    //                    for dict :[String : Any] in dataArray{
                    //                        var newDict = [String : Any]()
                    //                        newDict = dict
                    //                        let mainDict : [String : Any] = dict["main_free_user_id"] as! [String : Any]
                    //                        newDict["balance"] = mainDict["balance"]
                    //                        newDict["main_free_user"] = mainDict["_id"]
                    //                        arr.append(newDict)
                    //                    }
                    
                    MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                        let objArray = FEMDeserializer.collection(fromRepresentation: dataArray, mapping: UserList.defaultMapping(), context: localContext)
                        DispatchQueue.main.async {
                            self.itemLoadedBlock(objArray,"")
                        }
                    })
                    
                    
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        request.startRequest()
    }
    
    
    func checkUserExists(userList: Receiver, block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(KFreePhoneCheck_user)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let data = request.serverData["data"] as? [String : Any] {
                    print(data)
                    let aDict : [String : Any] = request.serverData as [String : Any]
                    let dataDict:[String : Any] = aDict["data"] as! [String : Any]
                    let id = dataDict["_id"] as! String
                    MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                        let obj = FEMDeserializer.object(fromRepresentation: data, mapping: Receiver.defaultMapping(), context: localContext)
                        DispatchQueue.main.async {
                            self.itemLoadedBlock(id,"")
                        }
                    })
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        let account : Account = AccountManager.instance().activeAccount!
        request.setParameter(userList.receiver_name!, forKey: "free_receiver_name")
        request.setParameter(userList.receiver_lname!, forKey: "free_receiver_lname")
        request.setParameter(userList.receiver_fname!, forKey: "free_receiver_fname")
        request.setParameter(userList.free_user_id!, forKey: "free_user_id")
        request.setParameter(account.userId, forKey: "user_id")
        request.startRequest()
    }
    
    func freePhoneDeposit(depositId:String, block : @escaping ItemLoadedBlock){
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kFreePhoneDeposit)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataDict = request.serverData["data"] as? [String : Any] {
                    print(dataDict)
                    if let requestDict = dataDict["request"]  as? [String : Any]{
                        print(requestDict)
                        if let uriDict = requestDict["uri"]  as? [String : Any]{
                            print(uriDict)
                            if let aStrId = uriDict["redirect_url"] as? String{
                                self.itemLoadedBlock(aStrId,"")
                            }
                        }
                    }
                }
                else {
                    self.itemLoadedBlock("",message as String)
                }
            }
            else {
                self.itemLoadedBlock("",message as String)
            }
        }
        
        request.setParameter(depositId, forKey: "deposit_id")
        request.startRequest()
    }
    
    func addFreePhoneDeposit(receiver: Receiver, block : @escaping ItemLoadedBlock){
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(KFreePhoneAddDeposit)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataDict = request.serverData["data"] as? [String : Any] {
                    MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                        FreePhoneDeposit.mr_truncateAll(in: localContext)
                        let obj = FEMDeserializer.object(fromRepresentation: dataDict, mapping: FreePhoneDeposit.defaultMapping(), context: localContext)
                        DispatchQueue.main.async {
                            self.itemLoadedBlock(obj,"")
                        }
                    })
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        
        request.setParameter(receiver.main_free_user_id!, forKey: "rec_id")
        let value_amount = String(format: "%.2f",receiver.amount?.floatValue ?? 0.00)
        request.setParameter(value_amount, forKey: "amount")
        let value_commission = String(format: "%.2f",receiver.commission?.floatValue ?? 0.00)
        request.setParameter(value_commission, forKey: "commission")
        let value = String(format: "%.2f",receiver.total_amout?.floatValue ?? 0.00)
        request.setParameter(value, forKey: "total_amount")
        request.startRequest()
    }
    
    func registerFreePhoneUser(firstName:String, lastName:String, block: @escaping ItemLoadedBlock)  {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(KRegisterFreePhoneUser)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                let aDict : [String : Any] = request.serverData as [String : Any]
                let dataDict:[String : Any] = aDict["data"] as! [String : Any]
                self.itemLoadedBlock(dataDict,"")
//                let id = dataDict["_id"] as! String
//                MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
//                    _ = FEMDeserializer.object(fromRepresentation: dataDict, mapping: Receiver.defaultMapping(), context: localContext)
//                    DispatchQueue.main.async {
//                        self.itemLoadedBlock(dataDict,"")
//                        //                        block(obj,"")
//                    }
//                })
            }else{
                self.itemLoadedBlock("",message as String)
            }
        }
        request.setParameter(firstName, forKey: "free_receiver_fname")
        request.setParameter(lastName, forKey: "free_receiver_lname")
        request.setParameter("\(firstName) \(lastName)", forKey: "free_receiver_name")
        request.startRequest()
    }
    
    func createFreePhoneUser(deposit_id:String, block: @escaping ItemLoadedBlock)  {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kCreateUser)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataDict = request.serverData["data"] as? [String : Any] {
                    let id = dataDict["_id"] as! String
                    MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                        let obj = FEMDeserializer.object(fromRepresentation: dataDict, mapping: Receiver.defaultMapping(), context: localContext)
                        DispatchQueue.main.async {
                            self.itemLoadedBlock(id,"")
                        }
                    })
                }
            }else{
                self.itemLoadedBlock("",message as String)
            }
        }
        request.setParameter(deposit_id, forKey: "deposit_id")
        request.startRequest()
    }
    
    func getAppStatus(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kGetAppStatus)", method: RequestMethod(rawValue: "GET")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataDict = request.serverData["data"] as? [String : Any] {
                    print(dataDict)
                    self.itemLoadedBlock(dataDict,"")
                }
                else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        request.startRequest()
    }
    
    func loadFreephoneCommission(amount:String, block : @escaping ItemLoadedBlock){
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kGetFreephoneCommission)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataDict = request.serverData["data"] as? [String : Any] {
                    DispatchQueue.main.async {
                        let total_amount  = dataDict["total_amount"]!
                        self.itemLoadedBlock(total_amount, "")
                        
                    }
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        let commissionAmount  = amount.replacingOccurrences(of: "₪", with: "")
        request.setParameter(commissionAmount, forKey: "amount")
        request.startRequest()
    }
    
    func loadFreePhoneCalculationCommission(block : @escaping ItemLoadedBlock) {
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kGetFreephoneCalcukateCommission)", method: RequestMethod(rawValue: "GET")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                if let dataArray = request.serverData["data"] as? [[String : Any]] {
                    MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                        let arr = FEMDeserializer.collection(fromRepresentation: dataArray, mapping: FreePhoneCommissionCalculation.defaultMapping(), context: localContext)
                        DispatchQueue.main.async {
                            self.itemLoadedBlock(arr,"")
                        }
                    })
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        request.startRequest()
    }
    
    //MARK: Api For Cantina and freephone user list
    
    func getCantinaAndFreePhoneUserList(block : @escaping ItemLoadedBlock){
        itemLoadedBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kGetCantinaANDFreephoneReceiverList)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                
                if let dataDict = request.serverData["data"] as? [[String : Any]] {
                    MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                        Receiver.mr_truncateAll(in: localContext)
                        let obj = FEMDeserializer.collection(fromRepresentation: dataDict, mapping: Receiver.defaultMapping(), context: localContext)
                        DispatchQueue.main.async {
                            self.itemLoadedBlock(obj,"")
                        }
                    })
                } else {
                    self.itemLoadedBlock("",message as String)
                }
            } else {
                self.itemLoadedBlock("",message as String)
            }
        }
        
        request.setParameter(AccountManager.instance().activeAccount?.userId ?? "", forKey: "user")
        request.startRequest()
    }
    
}
