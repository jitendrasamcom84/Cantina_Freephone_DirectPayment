//
//  FreePhoneSuccessWithUserInfoVC.swift
//  Cantina
//
//  Created by Mac on 26/09/18.
//  Copyright © 2018 AppToDate. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FreePhoneSuccessWithUserInfoVC: BaseViewController, NVActivityIndicatorViewable {
    
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblUserNumber: UILabel!
    @IBOutlet var lblInitalPassword: UILabel!
    
    var depositInfo = FreePhoneDeposit()
    var userList = FreePhoneUser()
    var receiver = Receiver()

    //MARK: Initializer
    
    class func initViewController(deposit:FreePhoneDeposit, user: Receiver) -> FreePhoneSuccessWithUserInfoVC {
        let vc = FreePhoneSuccessWithUserInfoVC.init(nibName: "FreePhoneSuccessWithUserInfoVC", bundle: nil)
        vc.depositInfo = deposit
        vc.receiver = user
        return vc
    }

    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUserApi()
        self.userId = receiver.entity_id!
//        let user : UserList = UserList.getbyId(userId: userList.entity_id)
//        user.delete()
    }
    
    func createUserApi() {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        
        Manager.sharedManager().createFreePhoneUser(deposit_id: depositInfo.entity_id!) { (result, errorMessage) -> (Void) in
            self.stopAnimating()
            if(errorMessage.count > 0){
                Utils.showAlert(withMessage: errorMessage)
            }else{
                self.createLayout()
                UserDefaults.standard.set(false, forKey: isFreePhoneNewUser)
                let id : String = result as! String
                let user : Receiver = Receiver.getbyId(userId: id)
                self.receiver = user
                let freeUserID =  user.free_user_id
                self.lblUserNumber.attributedText = self.textFormat(normaltxt: "מספר משתמש : ", boldtxt: freeUserID ?? "")
                let freeUserPwd = user.free_user_pass
                self.lblInitalPassword.attributedText = self.textFormat(normaltxt: "סיסמא ראשונית : ", boldtxt: freeUserPwd ?? "")
                
//                let dict : [String:Any] = result as! [String:Any]
//                let freeUserID = dict["free_user_id"] as! String
//                self.lblUserNumber.attributedText = self.textFormat(normaltxt: "מספר משתמש : ", boldtxt: freeUserID)
//                let freeUserPwd = dict["free_user_pass"] as! String
//                self.lblInitalPassword.attributedText = self.textFormat(normaltxt: "סיסמא ראשונית : ", boldtxt: freeUserPwd)
            }
        }
    }
    
    //MARK: Custom Method
    
    func createLayout()  {
        lblUserName.text =  receiver.receiver_name?.uppercased()
    }

    //MARK: IB Actions
    
    @IBAction func backToHomeClicked(_ sender: Any) {
//        let dictReceiver:[String: Receiver] = ["data": receiver]
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kCheckUserExistsWithObject), object: nil, userInfo: dictReceiver)
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kCheckUserExists), object: nil)

        let controller = DepositMoneyVC.initViewController(user: receiver, isFromNotification: true)
        UserDefaults.standard.set(false, forKey: isFreePhoneNewUser)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: Custom Method To Change Text Style Format
    func textFormat(normaltxt:String,boldtxt: String) -> NSMutableAttributedString {
        let boldText  = boldtxt
        let attrBold = [NSAttributedStringKey.font : UIFont(name: "Rubik-Medium", size: 18)!]
        let attrNormal = [NSAttributedStringKey.font : UIFont(name: "Rubik-Regular", size: 18)!]
        
        let strBold = NSAttributedString(string:boldText, attributes:attrBold)
        let strNormal = NSAttributedString(string:normaltxt, attributes:attrNormal)
        
        let combination:NSMutableAttributedString = NSMutableAttributedString(attributedString: strNormal)
        combination.append(strBold)
        
        return combination
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
