
import UIKit

typealias AccountBlock = (_ success : Bool, _ request: Account, _ errorMessage: String) -> (Void)

let aTypeProf : String = "1"
let aTypePriv : String = "0"

class Account: NSObject ,NSCoding {
    var accountBlock: AccountBlock  = {_,_,_ in }
    
    var username : String = ""
    var companyCode : String = ""
    var listOfGroups: NSArray = []
    var deviceId : String = ""
    var password : String = ""
    var phone : String = ""
    var userId : String = ""
    var accessToken : String = ""
    var token : String = ""
    
    let ENCODING_VERSION:Int = 1;
    
    override init() {}
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(ENCODING_VERSION, forKey: "version");
        aCoder.encode(username, forKey: "userName");
        aCoder.encode(phone, forKey: "phone");
        aCoder.encode(userId, forKey: "userId");
        aCoder.encode(accessToken, forKey: "accessToken");
        aCoder.encode(token, forKey: "token");
    }
    
    required init?(coder aDecoder: NSCoder) {
        if(aDecoder.decodeInteger(forKey: "version") == ENCODING_VERSION) {
            username = aDecoder.decodeObject(forKey: "userName") as! String;
            phone = aDecoder.decodeObject(forKey: "phone") as! String;
            userId = aDecoder.decodeObject(forKey: "userId") as! String;
            accessToken = aDecoder.decodeObject(forKey: "accessToken") as! String;
            token = aDecoder.decodeObject(forKey: "token") as! String;
        }
    }
    
    func parseDict(inDict:NSDictionary) {
        let userDict = inDict.value(forKey: "user") as! NSDictionary
        if let aStr = userDict.value(forKey: "name") as? String{
            self.username = aStr
        }
        if let aStrP = userDict.value(forKey: "phone") as? String{
            self.phone = aStrP
        }
        if let aStrId = userDict.value(forKey: "id") as? String{
            self.userId = aStrId
        }
        if let aStrtoken = inDict.value(forKey: "access_token") as? String{
            self.accessToken = aStrtoken
            Utils.setStringForKey("bearer \(self.accessToken)", key: kLoginAutheticationHeader)
        }
    }
    
    func login(password:String, block: @escaping AccountBlock)  {
        accountBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kLogin)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                let aDict = request.serverData as NSDictionary
                let dataDict:NSDictionary = aDict.object(forKey: "data") as! NSDictionary
                if (dataDict.value(forKey: "user") != nil) {
                    let userDict = dataDict.value(forKey: "user") as! NSDictionary
                    print(userDict)
                    self.parseDict(inDict: dataDict)
                }
                self.accountBlock(true,self,"")
            }else{
                self.accountBlock(false,self,message as String)
            }
        }
        let p = Utils.getPhoneNumberWithCode(phone: phone)
        request.setParameter(p, forKey: "phone")
        request.setParameter(password, forKey: "password")
        request.startRequest()
    }
    
    func registerUser(password: String, block: @escaping AccountBlock)  {
        accountBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kRegister)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                let aDict = request.serverData as NSDictionary
                if (aDict.value(forKey: "data") != nil) {
                    let bDict = aDict.value(forKey: "data") as! NSDictionary
                    print(bDict)
                    self.parseDict(inDict: bDict)
                }
                self.accountBlock(true,self,"")
            }else{
                self.accountBlock(false,self,message as String)
            }
        }
        let p = Utils.getPhoneNumberWithCode(phone: phone)
        request.setParameter(p, forKey: "phone")
        request.setParameter(password, forKey: "password")
        request.setParameter(username, forKey: "name")
        request.setParameter(Utils.fetchString(forKey: kFCMToken), forKey: "fcmRegId")
        request.setParameter(Utils.fetchString(forKey: kPaymentType), forKey: "type")
        request.startRequest()
    }
    
    func forgotPassword(password:String, block: @escaping AccountBlock)  {
        accountBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kForgotPassword)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                let aDict = request.serverData as NSDictionary
                if (aDict.value(forKey: "data") != nil) {
                    let bDict = aDict.value(forKey: "data") as! NSDictionary
                    print(bDict)
                }
                self.accountBlock(true,self,"")
            }else{
                self.accountBlock(false,self,message as String)
            }
        }
        
        let p = Utils.getPhoneNumberWithCode(phone: phone)
        request.setParameter(p, forKey: "phone")
        request.setParameter(password, forKey: "password")
        request.startRequest()
    }
    
    
    func contactUs(name : String , phone : String , message : String , type : String , block : @escaping AccountBlock) {
        accountBlock = block
        let request = Request.init(url: "\(kBaseUrl)\(kContactUs)", method: RequestMethod(rawValue: "POST")!) { (success:Bool, request:Request, message:NSString) -> (Void) in
            if(request.isSuccess){
                let msg  = request.serverData["message"];
                self.accountBlock(true,self,msg as! String)
            }else{
                self.accountBlock(false,self,message as String)
            }
        }
        let p = Utils.getPhoneNumberWithCode(phone: phone)        
        request.setParameter(name, forKey: "name")
        request.setParameter(p, forKey: "phone")
        request.setParameter(message, forKey: "message")
        request.setParameter(type, forKey: "type")
        request.startRequest()
    }
}
