//
//  FreePhoneSuccessVC.swift
//  Cantina
//
//  Created by samcom on 19/09/18.
//  Copyright © 2018 AppToDate. All rights reserved.
//

import UIKit

class FreePhoneSuccessVC: BaseViewController {

    @IBOutlet var btnBackOrContinue: UIButton!
    
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblUserId: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblCommissionAmount: UILabel!
    @IBOutlet var lblChargeAmount: UILabel!
    @IBOutlet var lblAmountClaim: UILabel!
    @IBOutlet var lblClaimNumber: UILabel!
    
    var diposite_number  = String();
    
    var depositInfo = FreePhoneDeposit()
    var userList = FreePhoneUser()
    var receiver = Receiver()
    

    @IBOutlet var btnBackWidthConstraint: NSLayoutConstraint!
    
    //MARK: Initializer
    
    class func initViewController(deposit: FreePhoneDeposit, user: Receiver) -> FreePhoneSuccessVC {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "FreePhoneSuccessVC") as! FreePhoneSuccessVC
        controller.depositInfo = deposit
        controller.receiver = user
        return controller
    }
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createLayout()
        setDetails()
        self.userId = receiver.entity_id!
    }
    
    //MARK: Custom Method
    
    func createLayout()  {
        if (UserDefaults.standard.bool(forKey: isFreePhoneNewUser) == true) {
            self.btnBackOrContinue.setTitle("המשך לקבלת פרטי המשתמש", for: .normal)
            btnBackWidthConstraint.constant = 335
        }
        else{
            self.btnBackOrContinue.setTitle("חזור למסך הבית", for: .normal)
            btnBackWidthConstraint.constant = 213
        }
    }
    
    //MARK: Set Details
    
    func setDetails() {
        print(depositInfo)
        lblUserName.text = receiver.receiver_name?.uppercased()
        
        //UserId
        if Utils.fetchBool(forKey: isFreePhoneNewUser) == true {
            lblUserId.isHidden = true
        }else{
            lblUserId.isHidden = false
            lblUserId.text = "מספר משתמש : " + (receiver.free_user_id)!
        }
        
        //Date
        let transaction_date = DateUtils.getDateStringddMyy(date: depositInfo.dateAdded!)
        lblDate.text = "בתאריך : " + transaction_date
        
        //Commission Amount
        lblCommissionAmount.text =  "סכום עמלה : " + Utils.getFractionPart(amount:String((depositInfo.commission?.stringValue)!)) + " ₪"
        
        //Total Sum
        lblChargeAmount.text = "סכום לחיוב : " + Utils.getFractionPart(amount:String((depositInfo.total_amount?.stringValue)!)) + " ₪"
        
        //Deposit Sum
        let str = depositInfo.amount?.stringValue
        let str2 = Utils.getModifyCurrencyStyle("₪\(Utils.getFractionPart(amount: str ?? "0.00"))", font:UIFont(name: "Rubik-Medium", size: 8))
        
        let att = NSMutableAttributedString(string: "סכום הטענה : ")
        att.append(str2!)
        lblAmountClaim.attributedText =  att
        
        //Transaction Id
        lblClaimNumber.attributedText = self.textFormat(normaltxt: " מספר הטענה : ", boldtxt: (depositInfo.paymentid?.stringValue)!)
    }

    //MARK: - IB's ACTION
    
    @IBAction func backToHomeClicked(_ sender: Any) {
        if (UserDefaults.standard.bool(forKey: isFreePhoneNewUser) == true) {
            //New Registered
            let vc = FreePhoneSuccessWithUserInfoVC.initViewController(deposit: depositInfo, user: receiver)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            //Already Registered User
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kCheckUserExists), object: nil)
            
            let dictReceiver:[String: Receiver] = ["data": receiver]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kCheckUserExistsWithObject), object: nil, userInfo: dictReceiver)
        }
    }
    
    //MARK: Custom Method To Change Text Style Format
    func textFormat(normaltxt:String,boldtxt: String) -> NSMutableAttributedString {
        let boldText  = boldtxt
        let attrBold = [NSAttributedStringKey.font : UIFont(name: "Rubik-Medium", size: 17)!]
        let attrNormal = [NSAttributedStringKey.font : UIFont(name: "Rubik-Regular", size: 17)!]
        
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
