
import UIKit
import Foundation
import Alamofire

typealias ResponseBlock = (_ success : Bool, _ request: Request, _ errorMessage: NSString) -> (Void)

public enum RequestMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
    case multiPartForm = "MULTI_PART_FORM"
}

class Request: NSObject {
    var methodType : RequestMethod = RequestMethod(rawValue: "GET")!
    var params:[String:Any] = [:]
    var responseBlock: ResponseBlock  = {_,_,_ in }
    var _urlPart = NSString()
    var postParameters: [String:Any] = [:]
    var isSuccess = Bool()
    var serverData = [String :Any]()
    var headers = HTTPHeaders()
    
    init(url urlString: String, method: RequestMethod, block: @escaping ResponseBlock) {
        super.init()
        _urlPart = urlString as NSString
        methodType = method
        postParameters = [String:Any]()
        responseBlock = block
    }
    
    func setParameter(_ parameter: Any, forKey key: String) {
        postParameters[key] = parameter
    }
    
    func setParameter(dist_flag : String , lati : String , longi : String , owners : [String] ){
        let parameters = [
            "dist_flag": dist_flag,
            "lati": lati,
            "longi": longi,
            "owners": owners
            ] as [String : Any]
        postParameters = parameters;
    }
    
    func startRequest()  {
        let account = AccountManager.instance().activeAccount
        if account != nil{
            headers = ["Authorization" : Utils.fetchString(forKey: kLoginAutheticationHeader)]
        }
//        headers = ["Authorization" : "wqweeqweqeqwqwqwerrwrwrewsddaddasdadadad"]
        if methodType == RequestMethod.get{
            self .requestGETURL(_urlPart as String, success: { (JSON) in
                self.serverData = JSON.dictionaryObject!
                self.isSuccess = true
                if let msg = self.serverData["message"] as? String {
                    self.isSuccess = true
                    self.requestSuccess(msg: msg)
                } else {
                    self.isSuccess = true
                    self.requestSuccess(msg: "")
                }
            }, failure: { (Error) in
                self.isSuccess = false
                self.requestFailedWithError(error: Error as NSError)
            })
        } else  if methodType == RequestMethod.post {
            self .requestPOSTURL(_urlPart as String, success: { (JSON) in
                self.serverData = JSON.dictionaryObject!
                if let is_error = self.serverData["is_error"] as? Bool {
                    if is_error {
                        self.isSuccess = false
                        let userInfo: [AnyHashable : Any] = [ NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: self.serverData["message"] as! String, comment: "") , NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: self.serverData["message"] as! String, comment: "") ]
                        let err = NSError(domain: "ShiploopHttpResponseErrorDomain", code: 401, userInfo: userInfo as? [String : Any])
                        self.requestFailedWithError(error:err)
                    } else {
                        if let msg = self.serverData["message"] as? String {
                            self.isSuccess = true
                            self.requestSuccess(msg: msg)
                        } else {
                            self.isSuccess = true
                            self.requestSuccess(msg: "")
                        }
                    }
                } else {
                    if let msg = self.serverData["message"] as? String {
                        self.isSuccess = true
                        self.requestSuccess(msg: msg)
                    } else {
                        self.isSuccess = true
                        self.requestSuccess(msg: "")
                    }
                }
            }, failure: { (Error) in
                self.isSuccess = false
                self.requestFailedWithError(error: Error as NSError)
            })
        } else  if methodType == RequestMethod.put {
            self .requestPUTURL(_urlPart as String, success: { (JSON) in
                self.serverData = JSON.dictionaryObject!
                if let is_error = self.serverData["is_error"] as? Bool {
                    if is_error {
                        self.isSuccess = false
                        let userInfo: [AnyHashable : Any] = [ NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: self.serverData["message"] as! String, comment: "") , NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: self.serverData["message"] as! String, comment: "") ]
                        let err = NSError(domain: "ShiploopHttpResponseErrorDomain", code: 401, userInfo: userInfo as? [String : Any])
                        self.requestFailedWithError(error:err)
                    } else {
                        if let msg = self.serverData["message"] as? String {
                            self.isSuccess = true
                            self.requestSuccess(msg: msg)
                        } else {
                            self.isSuccess = true
                            self.requestSuccess(msg: "")
                        }
                    }
                } else {
                    if let msg = self.serverData["message"] as? String {
                        self.isSuccess = true
                        self.requestSuccess(msg: msg)
                    } else {
                        self.isSuccess = true
                        self.requestSuccess(msg: "")
                    }
                }
            }, failure: { (Error) in
                self.isSuccess = false
                self.requestFailedWithError(error: Error as NSError)
            })
        } else if methodType == RequestMethod.delete {
            self .requestDELETEURL(_urlPart as String, success: { (JSON) in
                self.serverData = JSON.dictionaryObject!
                if let is_error = self.serverData["is_error"] as? Bool {
                    if is_error {
                        self.isSuccess = false
                        let userInfo: [AnyHashable : Any] = [ NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: self.serverData["message"] as! String, comment: "") , NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: self.serverData["message"] as! String, comment: "") ]
                        let err = NSError(domain: "ShiploopHttpResponseErrorDomain", code: 401, userInfo: userInfo as? [String : Any])
                        self.requestFailedWithError(error:err)
                    } else {
                        if let msg = self.serverData["message"] as? String {
                            self.isSuccess = true
                            self.requestSuccess(msg: msg)
                        } else {
                            self.isSuccess = true
                            self.requestSuccess(msg: "")
                        }
                    }
                } else {
                    if let msg = self.serverData["message"] as? String {
                        self.isSuccess = true
                        self.requestSuccess(msg: msg)
                    } else {
                        self.isSuccess = true
                        self.requestSuccess(msg: "")
                    }
                }
            }, failure: { (Error) in
                self.isSuccess = false
                self.requestFailedWithError(error: Error as NSError)
            })
        }else if methodType == RequestMethod.multiPartForm {
            self .requestMULTIPARTURL(_urlPart as String, success: { (JSON) in
                self.serverData = JSON.dictionaryObject!
                if let is_error = self.serverData["is_error"] as? Bool {
                    if is_error {
                        self.isSuccess = false
                        let userInfo: [AnyHashable : Any] = [ NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: self.serverData["message"] as! String, comment: "") , NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: self.serverData["message"] as! String, comment: "") ]
                        let err = NSError(domain: "ShiploopHttpResponseErrorDomain", code: 401, userInfo: userInfo as? [String : Any])
                        self.requestFailedWithError(error:err)
                    } else {
                        if let msg = self.serverData["message"] as? String {
                            self.isSuccess = true
                            self.requestSuccess(msg: msg)
                        } else {
                            self.isSuccess = true
                            self.requestSuccess(msg: "")
                        }
                    }
                } else {
                    if let msg = self.serverData["message"] as? String {
                        self.isSuccess = true
                        self.requestSuccess(msg: msg)
                    } else {
                        self.isSuccess = true
                        self.requestSuccess(msg: "")
                    }
                }
            }, failure: { (Error) in
                self.isSuccess = false
                self.requestFailedWithError(error: Error as NSError)
            })
        }
    }
    
    func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL, method: .get, parameters: postParameters, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.response?.statusCode == 401{
                self.isSuccess = false
                let userInfo: [AnyHashable : Any] = [ NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "נא להתנתק ולהתחבר מחדש" , comment: "") , NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "נא להתנתק ולהתחבר מחדש", comment: "") ]
                let err = NSError(domain: "ShiploopHttpResponseErrorDomain", code: 401, userInfo: userInfo as? [String : Any])
                self.requestFailedWithError(error:err)
                return
            }
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    func requestPOSTURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL, method: .post, parameters: postParameters,encoding: JSONEncoding.default, headers: headers).responseJSON
            { (responseObject) -> Void in
                if responseObject.response?.statusCode == 401{
                    self.isSuccess = false
                    let userInfo: [AnyHashable : Any] = [ NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "נא להתנתק ולהתחבר מחדש" , comment: "") , NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "נא להתנתק ולהתחבר מחדש", comment: "") ]
                    let err = NSError(domain: "ShiploopHttpResponseErrorDomain", code: 401, userInfo: userInfo as? [String : Any])
                    self.requestFailedWithError(error:err)
                    return
                }
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson)
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
        }
    }
    
    func requestPUTURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL, method: .put, parameters: postParameters,encoding: JSONEncoding.default, headers: headers).responseJSON
            { (responseObject) -> Void in
                if responseObject.response?.statusCode == 401{
                    self.isSuccess = false
                    let userInfo: [AnyHashable : Any] = [ NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "נא להתנתק ולהתחבר מחדש" , comment: "") , NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "נא להתנתק ולהתחבר מחדש", comment: "") ]
                    let err = NSError(domain: "ShiploopHttpResponseErrorDomain", code: 401, userInfo: userInfo as? [String : Any])
                    self.requestFailedWithError(error:err)
                    return
                }
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson)
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
        }
    }
    
    func requestMULTIPARTURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        var fileData = Data()
        fileData = postParameters["file"] as! Data//[String:Any
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(fileData, withName: "file", fileName: "image", mimeType: "image/jpeg")},
                         usingThreshold:UInt64.init(),
                         to:strURL,
                         method:.post,
                         headers:headers,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                    print(response.result)
                                    let resJson = JSON(response.result.value!)
                                    success(resJson)
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                failure(encodingError)
                            }
        })
    }
    
    func requestDELETEURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL, method: .delete, parameters: postParameters , headers: headers ).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    func requestSuccess(msg:String)  {
        responseBlock(true,self,msg as NSString)
    }
    func requestFailedWithError (error: NSError){
        responseBlock(false, self,error.localizedDescription as NSString)
    }
}

