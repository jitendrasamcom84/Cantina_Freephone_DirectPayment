//
//  FreePhonePaymentVC.swift
//  Cantina
//
//  Created by Mac on 25/09/18.
//  Copyright © 2018 AppToDate. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FreePhonePaymentVC: BaseViewController, UIWebViewDelegate, NVActivityIndicatorViewable {

    @IBOutlet var btnAgreeTerms: UIButton!
    
    @IBOutlet var lblAmount: UILabel!
    
    @IBOutlet var freePhoneWebView: UIWebView!
    
    @IBOutlet var txtFirstName: customTextField!
    @IBOutlet var txtLastName: customTextField!
    @IBOutlet var txtId: customTextField!
    @IBOutlet var txtCreditCardNumber: customTextField!
    @IBOutlet var txtYear: customTextField!
    @IBOutlet var txtCvv: customTextField!
    
    var passAmount = String()
    var totalAmount = String()
    var commissionAmount = String()
    var amountWithCommission = String()
    var paymentDiposite_number : String = ""
    var userList : Receiver = Receiver()
    var isFromManualEnter_field : Bool = false
    //MARK: Initializer
    
    class func initViewController(user:Receiver) -> FreePhonePaymentVC {
        let vc = FreePhonePaymentVC.init(nibName: "FreePhonePaymentVC", bundle: nil)
        vc.userList = user
        return vc
    }
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str1 = Utils.getFractionPart(amount: amountWithCommission)
        lblAmount.attributedText =  Utils.getModifyCurrencyStyle(str1, font:UIFont(name: "Rubik-Medium", size: 8))
        
        self.userId = userList.entity_id!
    }
    
    override func viewWillAppear(_ animated: Bool)    {
        super.viewWillAppear(animated)
        self.freePhoneAddDepositApiCall()
    }
    
    //MARK: Free Phone Add Deposit Api Call
    func freePhoneAddDepositApiCall() {
        let array:[String] = (lblAmount.text?.components(separatedBy: "₪"))!
        if(array.count == 2){
            let account = AccountManager.instance().activeAccount
            if account != nil{
                let amountString : Float = Float(array[1])!
                if(amountString <= 0){
                    Utils.showAlert(withMessage: "הזן סכום חוקי")
                    return
                }
                
                commissionAmount = commissionAmount.replacingOccurrences(of: "₪", with: "")
                commissionAmount = Utils.getFractionPart(amount: commissionAmount)
                let commission = commissionAmount
                userList.commission = NSNumber.init(value: Float(commission) ?? 0.00 )

                amountWithCommission = amountWithCommission.replacingOccurrences(of: "₪", with: "")
                let total = Float(amountWithCommission)
                userList.total_amout = NSNumber.init(value: total ?? 0.00)
                
                passAmount = passAmount.replacingOccurrences(of: "₪", with: "")
                let amount = Float(passAmount)
                userList.amount = NSNumber(value: amount!)
                
                startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
                Manager.sharedManager().addFreePhoneDeposit(receiver: userList) { (response, errorMessage) -> (Void) in
                    self.stopAnimating()
                    if errorMessage.count > 0{
                        Utils.showAlert(withMessage: errorMessage)
                        return
                    }
                    
                    self.loadUserListApi()
                    self.freePhoneDepositApiCall()
                }
            }
        }
    }
    func loadUserListApi() {
        Manager.sharedManager().getCantinaAndFreePhoneUserList { (result, errorMessage) -> (Void) in
            
        }
//        Manager.sharedManager().loadUserList { (result, errorMessage) -> (Void) in
//        }
    }
    //MARK: Free Phone Deposit Api Call
    
    func freePhoneDepositApiCall() {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        let deposit: FreePhoneDeposit = FreePhoneDeposit.getFreePhoneDeposit()
        
        Manager.sharedManager().freePhoneDeposit(depositId: (deposit.entity_id)!) { (result, errorMessage) -> (Void) in
            self.stopAnimating()
            if(errorMessage.count > 0){
                Utils.showAlert(withMessage: errorMessage)
            }
            else{
                DispatchQueue.main.async {
                    let original = result
                    self.startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
                    if let encoded = (original as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                        let url = URL(string: encoded) {
                        let urlReq : URLRequest = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 80)
                        self.freePhoneWebView.loadRequest(urlReq)
                    }
                }
            }
        }
    }
    
    //MARK: IB Actions
    
    @IBAction func backClicked(_ sender: Any) {
        if (UserDefaults.standard.bool(forKey: isFreePhoneNewUser) == true) {
            let alert = UIAlertController.init(title: "", message:"במידה ותחזור למסך הקודם תהליך ההרשמה של משתמש פריפון חדש יפסק, להמשיך בכל זאת?", preferredStyle: .alert)
            let yesAction = UIAlertAction.init(title: "חזרה לאחור", style: .default) { (action) in
                self.deleteUser(id: self.userList.entity_id!)
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
    
    @IBAction func submitClicked(_ sender: Any) {
    }
    
    @IBAction func saveCardDetailClicked(_ sender: Any) {
    }
    
    @IBAction func agreeTermsClicked(_ sender: Any) {
        if btnAgreeTerms.isSelected {
            btnAgreeTerms.isSelected = false
            UIView.transition(with: sender as! UIView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                (sender as AnyObject).setImage(UIImage(named: "check-mark"), for: .normal)
            }, completion: nil)
        } else {
            btnAgreeTerms.isSelected = true
            UIView.transition(with: sender as! UIView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                (sender as AnyObject).setImage(UIImage(named: ""), for: .normal)
            }, completion: nil)
        }
    }
    
    //MARK: WebView Delegate Method
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("Loading")
        self.stopAnimating()
        if let text = webView.request?.url?.absoluteString{
            print("Tranzila URL:  \(text)")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let strSuccess = "\(kBaseUrl)\(kPaymentUrl)paymentsuccessnew" //"http://109.237.25.22:3051/api/payments/paymentsuccess"
            let strFail = "\(kBaseUrl)\(kPaymentUrl)paymentfailnew" //"http://109.237.25.22:3051/api/payments/paymentfail"
            if(text.contains("paymentsuccessnew")){
                let depositInfo = FreePhoneDeposit.getFreePhoneDeposit()
                let controller = FreePhoneSuccessVC.initViewController(deposit: depositInfo, user: userList)
                self.navigationController?.pushViewController(controller, animated: true)
            } else if(text.contains("paymentfailnew")){
                let controller = storyBoard.instantiateViewController(withIdentifier: "FailureFreePhoneVC") as! FailureFreePhoneVC
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        Utils.showAlert(withMessage: error.localizedDescription)
        self.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
