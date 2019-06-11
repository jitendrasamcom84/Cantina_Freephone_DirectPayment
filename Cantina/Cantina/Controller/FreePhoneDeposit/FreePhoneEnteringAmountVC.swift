//
//  FreePhoneEnteringAmountVC.swift
//  Cantina
//
//  Created by Mac on 24/09/18.
//  Copyright © 2018 AppToDate. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class FreePhoneEnteringAmountVC: BaseViewController, NVActivityIndicatorViewable {
    

    @IBOutlet var btnSubmit: UIButton!
    
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblCommissionAmount: UILabel!
    var id = String()
    
    //var userList = FreePhoneUser()
    
    var receiver : Receiver = Receiver()

    //MARK: Initializer
    
    class func initViewController(user:Receiver) -> FreePhoneEnteringAmountVC {
        let vc = FreePhoneEnteringAmountVC.init(nibName: "FreePhoneEnteringAmountVC", bundle: nil)
        vc.receiver = user
        return vc
    }
    
    class func initViewController(user:String) -> FreePhoneEnteringAmountVC {
        let vc = FreePhoneEnteringAmountVC.init(nibName: "FreePhoneEnteringAmountVC", bundle: nil)
        vc.id = user
        return vc
    }
    
    //MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLayout()
        self.submitButtonVisibility()
        
        receiver = Receiver.getbyId(userId: id)
        
        self.userId = id
    }
    
    func createLayout() {
        btnSubmit.isEnabled = true
        btnSubmit.alpha = 0.3
        btnSubmit.isUserInteractionEnabled = true
    }

    //MARK: IB Actions
    
    @IBAction func backClicked(_ sender: Any) {
        if (UserDefaults.standard.bool(forKey: isFreePhoneNewUser) == true) {
            let alert = UIAlertController.init(title: "", message:"במידה ותחזור למסך הקודם תהליך ההרשמה של משתמש פריפון חדש יפסק, להמשיך בכל זאת?", preferredStyle: .alert)
            let yesAction = UIAlertAction.init(title: "חזרה לאחור", style: .default) { (action) in
                self.deleteUser(id: self.id)
            }
            let noAction = UIAlertAction.init(title: "ביטול", style: .default) { (action) in
            }
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func btnDIgitsClicked(_ sender: UIButton){
        if lblAmount.text == "₪0"{
            btnSubmit.isEnabled = true
            lblAmount.text = "₪" + String(sender.tag)
        }else{
            btnSubmit.isEnabled = true
            lblAmount.text = lblAmount.text! + String(sender.tag)
        }
        let amount = lblAmount.text?.replacingOccurrences(of: "₪", with: "")
        let  castAmount : Float = Float(amount!)!
        if(castAmount <= 0){
            btnSubmit.alpha = 0.3
            btnSubmit.isEnabled = false
        }else{
            btnSubmit.alpha = 1
            btnSubmit.isEnabled = true
            self.myTextFieldDidChange(self.lblAmount)
        }
    }
    
    @IBAction func btnDotClicked(_ sender: UIButton){
        if lblAmount.text == "₪0"{
            btnSubmit.isEnabled = false
            btnSubmit.alpha = 0.3
        }else {
            btnSubmit.isEnabled = true
            btnSubmit.alpha = 1
        }
        var str = lblAmount.text
        let character: Character = "."
        if !(str?.characters.contains(character))! {
            lblAmount.text = lblAmount.text! + "."
        }
        let amount = lblAmount.text?.replacingOccurrences(of: "₪", with: "")
        let  castAmount : Float = Float(amount!)!
        if(castAmount <= 0){
            btnSubmit.alpha = 0.3
            btnSubmit.isEnabled = false
        }else{
            btnSubmit.alpha = 1
            btnSubmit.isEnabled = true
        }
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton){
        self.submitButtonVisibility()
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        var amount = lblAmount.text?.replacingOccurrences(of: "₪", with: "")
        let  castAmount : Float = Float(amount!)!
        if(castAmount <= 0){
            Utils.showAlert(withTitle: tMissingItems, withMessage: "הזן סכום חוקי", withButtonTitle:tApproval.localized)
            return;
        }
        let account = AccountManager.instance().activeAccount
        if account != nil{
            
            self.startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)

            Manager.sharedManager().loadFreephoneCommission(amount: lblAmount.text!) { (response, errorMessage) -> (Void) in
                self.stopAnimating()
                if errorMessage.count > 0{
                    Utils.showAlert(withMessage: errorMessage)
                    return
                }
                
                let vc = FreePhonePaymentVC.initViewController(user: self.receiver)
                vc.passAmount = self.lblAmount.text!
                let a = String(describing: response)

                let b = Float(a)
                let c = Float(amount!)
                let d : Float = b! + c!
                amount = "₪" + String(d)

                vc.commissionAmount = a
                vc.amountWithCommission = amount!
                vc.totalAmount = self.lblAmount.text!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let loginController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let nav = UINavigationController.init(rootViewController: loginController)
            self.navigationController?.present(nav, animated: true, completion: nil)
        }
    }
    
    //MARK: Other Helper
    
    func submitButtonVisibility(){
        let name: String = lblAmount.text!
        var truncated = name.substring(to: name.index(before: name.endIndex))
        if truncated == "" || truncated  == "₪0" || truncated  == "₪" {
            truncated  = "₪0"
        }
        lblAmount.text = truncated
        self.myTextFieldDidChange(self.lblAmount)
        if lblAmount.text == "₪0"{
            btnSubmit.isEnabled = false
            btnSubmit.alpha = 0.3
            
        }else{
            btnSubmit.isEnabled = true
            btnSubmit.alpha = 1
        }
        let amount = lblAmount.text?.replacingOccurrences(of: "₪", with: "")
        let  castAmount : Float = Float(amount!)!
        if(castAmount <= 0){
            btnSubmit.alpha = 0.3
            btnSubmit.isEnabled = false
        }else{
            btnSubmit.alpha = 1
            btnSubmit.isEnabled = true
        }
    }
    
    func myTextFieldDidChange(_ label: UILabel) {
        var str = ""
        str = (label.text?.replacingOccurrences(of: "₪", with: ""))!
        label.text = "₪\(str )"
        calculateCommission(txt: str)
    }
    
    func calculateCommission(txt : String) {
        let commission : FreePhoneCommissionCalculation = FreePhoneCommissionCalculation.getFirst()
        let x = commission.x?.floatValue
        let y = commission.y?.floatValue
        let z1 : Float = commission.z1?.floatValue ?? 0
        let z2 : Float = commission.z2?.floatValue ?? 0
        
        let enteredAmount = (txt as NSString).floatValue
        let w = enteredAmount / 0.96
        let s1 = w * 0.04
        let s2 = y! + (x! * enteredAmount) / 100
        var s3 = s1 + s2
        
        if (s1 >= z2) {
            s3 = s1
        }
        else{
            if (s3 >= z2){
                s3 = z2
            }
            else {
                if (s3 <= z1){
                    s3 = z1
                }
                else{
                    s3 = s1 + s2
                }
            }
        }
        updateCommission(commissionAmount: s3)
        
//        var s2 = (x ?? 0.0 + (y ?? 0.0 * enteredAmount)) / 100
//        var s3 = s1 + s2
        
//        if s1 > z2 {
//            s3 = s1
//        }
//        else {
//            if (s3 > z2){
//                s2 = z2 - s1
//                s3 = s1 + s2
//            }
//            else if (s3 < z2){
//                s2 = z1
//                s3 = s1 + s2
//            }
//        }
        
        
//        let commission : FreePhoneCommissionCalculation = FreePhoneCommissionCalculation.getFirst()
//        let x = commission.x?.floatValue
//        let y = commission.y?.floatValue
//        let w = commission.w?.floatValue
//        var f = Float(txt)
//        if (f == nil) {
//            f = 0
//        }
//        let s = commission.s?.floatValue
//        let z1 = commission.z1?.floatValue
//        let z2 = commission.z2?.floatValue
//
//        let s1 = y! + (x!*f!)/100
//        let s2 = (w!*f!)/100
//
//        let s3 = s1 + s2
//
//        if (s! < z1!) {
//            self.updateCommission(commissionAmount:z1! + s2)
//        }
//        else if (s!>z2!){
//            self.updateCommission(commissionAmount:z2! + s2)
//        }
//        else{
//            self.updateCommission(commissionAmount:s3)
//        }
    }
        
    func updateCommission(commissionAmount : Float) {
        var c_amount = commissionAmount
        let str = (lblAmount.text?.replacingOccurrences(of: "₪", with: ""))!
        if str == "0" {
            lblCommissionAmount.isHidden = true
        }else{
            let comm_amount = String(format: "%.2f", Double(commissionAmount))
            let arr = comm_amount.split(separator: ".")
            print(arr)
            
            if(comm_amount.contains(".")){
                let arr = comm_amount.split(separator: ".")
                print(arr)
                let val : String = String(arr[1])
                let valueToCheck : String = String(val.first!)
                if valueToCheck == "0" {
                    c_amount = Float(arr[0])!
                }
                else if Int(valueToCheck)! > 5 {
                    c_amount = Float(Int(arr[0])! + 1)
                }
                else{
                    let amt = Double(arr[0])! + 0.5
                    c_amount = Float(amt)
                }
                
                let valueToDisplay = String(c_amount)
                if valueToDisplay.contains("0"){
                    lblCommissionAmount.isHidden = false
                    lblCommissionAmount.text = "לסכום ההפקדה תתווסף עמלת שירות בסך של \(Int(c_amount)) שח"
                }
                else {
                    lblCommissionAmount.isHidden = false
                    lblCommissionAmount.text = "לסכום ההפקדה תתווסף עמלת שירות בסך של \(c_amount) שח"
                }
            }
            
//            var beforePointValue : Int = 0
//            var afterPointValue : Int = 0
//            if let firstV : Int = Int(arr[1]) {
//                beforePointValue = firstV
//            }
//
//            if let lastV : Int = Int(arr[1]) {
//                afterPointValue = lastV
//            }
//
//            else if afterPointValue == 0 {
//                c_amount = Float(beforePointValue)
//            }
//
//            else if afterPointValue <= 5  {
//                beforePointValue = beforePointValue + Int(0.5)
//                c_amount = Float(beforePointValue)
//            }
//
//            else if afterPointValue > 5  {
//                afterPointValue = afterPointValue + 1
//                c_amount = Float(afterPointValue)
//            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
