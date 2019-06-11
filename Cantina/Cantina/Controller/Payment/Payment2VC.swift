import UIKit
import NVActivityIndicatorView


class Payment2VC: BaseViewController ,UITextFieldDelegate, UIWebViewDelegate, MyContactsVCDelegate , NVActivityIndicatorViewable{
    
    var btnHome = String()
    var passAmount = String()
    var totalAmount = String()
    
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtNum: UITextField!
    @IBOutlet var payImg: UIImageView!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblimgText: UILabel!
    @IBOutlet var btnChecked: UIButton!
    @IBOutlet var lblunderlineText: UILabel!
    var paymentDiposite_number : String = ""
    var isChecked = false
    @IBOutlet var webView: UIWebView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var isFromPaymentHistory : Bool = false
    var isFromHome : Bool = false
    @IBOutlet var lblTermCondition: UIButton!
    @IBOutlet var lblCommission: UILabel!
    var commissionAmount = String()
    var amountWithCommission = String()
    
    var receiver : Receiver = Receiver()
    var payment : Payment = Payment()
    
    //MARK: Initializer
    
    class func initViewController(contact:Receiver) -> Payment2VC {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "Payment2VC") as! Payment2VC
        controller.receiver = contact
        return controller
    }
    
    //MARK: - View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Manager.sharedManager().loadTranzilaToken { (result, errorMessage) -> (Void) in
//        }
        
        txtName.delegate = self;
        txtNum.delegate = self;
        lblTermCondition.alpha = 0
        btnChecked.alpha = 0;
        lblunderlineText.alpha = 0;
        
        if isFromPaymentHistory{
            txtName.text = payment.receiver_name
            txtNum.text = payment.receiver_id
            passAmount = "₪\(payment.amount!)"
            lblCommission.text = "לתשומת לבך: לסכום ההפקדה תתווסף עמלת שירות בסך של ₪\(Utils.getFractionPart(amount: commissionAmount))"
            lblAmount.text =  Utils.getFractionPart(amount: passAmount)
            if payment.payment_type == "0" {
                payImg.image = UIImage(named:"store")!
                lblimgText.text =  "הפקדה לקנטינה"
            } else {
                payImg.image = UIImage(named:"payment-method")!
                lblimgText.text = "הפקדה לפרי-פון"
            }
        }else if !isFromHome{
            txtName.text = receiver.receiver_name
            txtNum.text = receiver.receiver_id
            if receiver.amount != nil {
                lblAmount.text =  "₪\(receiver.amount!)"
                lblCommission.text = "לתשומת לבך: לסכום ההפקדה תתווסף עמלת שירות בסך של ₪\(Utils.getFractionPart(amount: commissionAmount))"
            }else{
                if(passAmount != nil){
                    lblAmount.text = Utils.getFractionPart(amount: passAmount)
                    lblCommission.text = "לתשומת לבך: לסכום ההפקדה תתווסף עמלת שירות בסך של ₪\(Utils.getFractionPart(amount: commissionAmount))"
                }else{
                    lblAmount.text =  "₪0"
                    lblCommission.text = "לתשומת לבך: לסכום ההפקדה תתווסף עמלת שירות בסך של ₪0"
                }
            }
            if receiver.type == "0" {
                payImg.image = UIImage(named:"store")!
                lblimgText.text =  "הפקדה לקנטינה"
            } else {
                payImg.image = UIImage(named:"payment-method")!
                lblimgText.text = "הפקדה לפרי-פון"
            }
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Payment2VC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        btnSubmit.alpha = 0.3;
        btnSubmit.isUserInteractionEnabled = false
        webView.isHidden = true
        lblAmount.text =  Utils.getFractionPart(amount: passAmount)
        lblCommission.text = "לתשומת לבך: לסכום ההפקדה תתווסף עמלת שירות בסך של ₪\(Utils.getFractionPart(amount: commissionAmount))"
        
        if  isFromHome { //btnHome == "1"
            payImg.image = UIImage(named:"store")!
            lblimgText.text =  "הפקדה לקנטינה"
        } else {
            payImg.image = UIImage(named:"payment-method")!
            lblimgText.text = "הפקדה לפרי-פון"
        }
        
        if isFromPaymentHistory{
            txtName.text = payment.receiver_name
            txtNum.text = payment.receiver_id
            passAmount = "₪\(payment.amount!)"
            lblAmount.text =  Utils.getFractionPart(amount: passAmount)
            lblCommission.text = "לתשומת לבך: לסכום ההפקדה תתווסף עמלת שירות בסך של ₪\(Utils.getFractionPart(amount: commissionAmount))"
            if payment.payment_type == "0" {
                payImg.image = UIImage(named:"store")!
                lblimgText.text =  "הפקדה לקנטינה"
            } else {
                payImg.image = UIImage(named:"payment-method")!
                lblimgText.text = "הפקדה לפרי-פון"
            }
        }else if !isFromHome{
            txtName.text = receiver.receiver_name
            txtNum.text = receiver.receiver_id
            if receiver.amount != nil {
                lblAmount.text =  "₪\(receiver.amount!)"
                lblCommission.text = "לתשומת לבך: לסכום ההפקדה תתווסף עמלת שירות בסך של ₪\(Utils.getFractionPart(amount: commissionAmount))"
            }else{
                if(passAmount != nil){
                    lblAmount.text =  Utils.getFractionPart(amount: passAmount)
                    lblCommission.text = "לתשומת לבך: לסכום ההפקדה תתווסף עמלת שירות בסך של ₪\(Utils.getFractionPart(amount: commissionAmount))"
                }else{
                    lblAmount.text =  "₪0"
                    lblCommission.text = "לתשומת לבך: לסכום ההפקדה תתווסף עמלת שירות בסך של ₪0"
                }
            }
            if receiver.type == "0" {
                payImg.image = UIImage(named:"store")!
                lblimgText.text =  "הפקדה לקנטינה"
            } else {
                payImg.image = UIImage(named:"payment-method")!
                lblimgText.text = "הפקדה לפרי-פון"
            }
        }
        let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "קראתי ואני מאשר/ת את תנאי השימוש", attributes: underlineAttribute)
        lblunderlineText.attributedText = underlineAttributedString
        submitButtonVisibility()
        termConditionButtonVisibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: MyContactsVCDelegate
    func selectedContact(contact: Receiver) {
        if contact.receiver_name == nil {
            return
        }
        txtName.text = contact.receiver_name
        txtNum.text = contact.receiver_id
        self.submitButtonVisibility()
    }
    
    @IBAction func backClicked(_ sender: Any) {
        amountDisplayForThePayStep2()
        if(webView.isHidden == true){
            self.navigationController?.popViewController(animated: true)
        }else{
            webView.isHidden = true
        }
    }
    
    @IBAction func termConditionTextClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsOfUseVC") as!  TermsOfUseVC
        vc.isFromDebitList = true
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureTextFields() {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.submitButtonVisibility();
    }
    
    
    func amountDisplayForThePayStep2() {
        if isFromPaymentHistory{
            passAmount = "₪\(Utils.getFractionPart(amount: String(describing: payment.amount!)))"
            lblAmount.text =  Utils.getFractionPart(amount: passAmount)
            
        }else if !isFromHome{
            
            if receiver.amount != nil {
                lblAmount.text =  "₪\(Utils.getFractionPart(amount: String(describing: receiver.amount!)))"
            }else{
                if(passAmount != nil){
                    lblAmount.text =  Utils.getFractionPart(amount: passAmount)
                    
                }else{
                    lblAmount.text =  "₪0"
                }
            }
        }else{
            lblAmount.text =  Utils.getFractionPart(amount: passAmount)
        }
    }
    
    func amountDisplayForThePayStep3() {
        
        if isFromPaymentHistory{
            passAmount = "₪\(payment.total_amount!)"
            
            lblAmount.text =  Utils.getFractionPart(amount: passAmount)
            
        }else if !isFromHome{
            
            if receiver.total_amout != nil {
                lblAmount.text =  "₪\(Utils.getFractionPart(amount: String(describing: receiver.total_amout!)))"
                
            }else{
                if(passAmount != nil){
                    amountWithCommission = passAmount
                    lblAmount.text =  Utils.getFractionPart(amount: passAmount)
                }else{
                    lblAmount.text =  "₪0"
                }
            }
        }else{
            lblAmount.text =  Utils.getFractionPart(amount: amountWithCommission)
        }
    }
    
    
    func submitButtonVisibility(){
        let FirstName = txtName.text!.trimmingCharacters(in: .whitespaces)
        let LastName = txtNum.text!.trimmingCharacters(in: .whitespaces)
        btnSubmit.alpha = 0.3;
        btnSubmit.isUserInteractionEnabled = false
        if FirstName.count > 0 && LastName.count > 0 && isChecked{
            btnSubmit.alpha = 1;
            btnSubmit.isUserInteractionEnabled = true
        }
        lblTermCondition.alpha = 0
        btnChecked.alpha = 0;
        lblunderlineText.alpha = 0;
        if FirstName.count > 0 && LastName.count > 0 {
            termConditionButtonVisibility()
        }
    }
    
    func termConditionButtonVisibility(){
        let FirstName = txtName.text!.trimmingCharacters(in: .whitespaces)
        let LastName = txtNum.text!.trimmingCharacters(in: .whitespaces)
        lblTermCondition.alpha = 0
        btnChecked.alpha = 0;
        lblunderlineText.alpha = 0;
        if FirstName.count > 0 && LastName.count > 0{
            lblTermCondition.alpha = 1;
            btnChecked.alpha = 1;
            lblunderlineText.alpha = 1;
        }
    }
    
    @IBAction func btnCheckBoxClicked(_ sender: UIButton){
        isChecked = !isChecked
        if isChecked {
            UIView.transition(with: sender as UIView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                sender.setImage(UIImage(named: "check-mark"), for: .normal)
            }, completion: nil)
        } else {
            UIView.transition(with: sender as UIView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                sender.setImage(UIImage(named: ""), for: .normal)
            }, completion: nil)
        }
        self.submitButtonVisibility()
    }
    
    @IBAction func btnSubmit(_ sender: Any){
        let array:[String] = (lblAmount.text?.components(separatedBy: "₪"))!
        if(array.count == 2){
            let account = AccountManager.instance().activeAccount
            if account != nil{
                let amountString : Float = Float(array[1])!
                if(amountString <= 0){
                    Utils.showAlert(withMessage: "הזן סכום חוקי")
                    return
                }
                let strName = txtName.text!.trimmingCharacters(in: .whitespaces)
                let strTxtNum = txtNum.text!.trimmingCharacters(in: .whitespaces)
                if (strName.count <= 0){
                    Utils.showAlert(withTitle: tMissingItems, withMessage: "נא להזין שם!", withButtonTitle:tApproval.localized)
                    return
                }else if (strTxtNum.count <= 0){
                    Utils.showAlert(withTitle: tMissingItems, withMessage: "הזן מספר חשבון!", withButtonTitle:tApproval.localized)
                    return
                }
                
                var total  : Float = Float(commissionAmount)! + amountString
                let vc = ThankYouVC.initViewController()
                vc.enteredAmount = Float(array[1]) as! Float
                vc.commissionAmount = Float(commissionAmount)!
                self.navigationController?.pushViewController(vc, animated: true)
                
//                startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
//                Manager.sharedManager().addPayment(totalAmount: String(total), amount:array[1] , receivername: txtName.text!, receiverId:txtNum.text! , block: { (response, errorMessage) -> (Void) in
//                    self.stopAnimating()
//                    if errorMessage.count > 0{
//                        Utils.showAlert(withMessage: errorMessage)
//                        return
//                    }
//
//                    self.paymentDiposite_number = response as! String;
//                    // MARK :: Condition for the TranzilaToken
//
////                    let arr : [TranzilaToken] = TranzilaToken.getAll()
//                    self.sendPaymentApi(paymentId: response as! String, is_save_card: "0")
////                    if(arr.count > 0){
////                        let tokenObject : TranzilaToken = arr[0]
////                        let lastFourDigit = tokenObject.card
////                        let message  = "האם ברצונך לבצע תשלום עם כרטיס המסתיים ב " + lastFourDigit!
////
////                        let alert = UIAlertController.init(title: "", message:message, preferredStyle: .alert)
////
////                        let approveAction = UIAlertAction.init(title: "אישור", style: .default) { (action) in
////                            self.sendPaymentApiTranzilaToken(token: tokenObject.token!, expDate: tokenObject.expdate!, paymentId:  response as! String)
////                        }
////                        let decilneAction = UIAlertAction.init(title: "שלם עם כרטיס אחר", style: .default) { (action) in
////                            self.sendPaymentApi(paymentId: response as! String, is_save_card: "0")
////                        }
////                        alert.addAction(decilneAction)
////                        alert.addAction(approveAction)
////                        self.present(alert, animated: true, completion: nil)
////                        return;
////
////                    }else{
////                        self.sendPaymentApi(paymentId: response as! String, is_save_card: "0")
////                    }
//                })
            }else{
                let loginController = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let nav = UINavigationController.init(rootViewController: loginController)
                self.navigationController?.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    func sendPaymentApiTranzilaToken(token: String , expDate : String , paymentId : String) {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        // MARK :: Sending paymentid , token , expDate for the token payment
        Manager.sharedManager().sendPaymentTranzilaToken(paymentId: paymentId ,token: token, expDate: expDate) { (response, errorMessage) -> (Void) in
            self.stopAnimating()
            if errorMessage.count > 0{
                let controller = storyBoard.instantiateViewController(withIdentifier: "ThankYou2VC") as! ThankYou2VC
                self.navigationController?.pushViewController(controller, animated: true)
                return
            }
            Manager.sharedManager().loadPaymenthistory(block: { (response, errorMessage) -> (Void) in
                self.paymentDiposite_number = paymentId;
                let controller = storyBoard.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
                controller.diposite_number = self.paymentDiposite_number;
                self.navigationController?.pushViewController(controller, animated: true)
            })
        }
    }
    
    func sendPaymentApi(paymentId: String , is_save_card : String) {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        Manager.sharedManager().sendPayment(paymentId:paymentId, is_save_card: is_save_card) { (response, errorMessage) -> (Void) in
            if errorMessage.count > 0{
                Utils.showAlert(withMessage: errorMessage)
                return
            }
            print(response as! String)
            
            self.webView.isHidden = false
            self.amountDisplayForThePayStep3()
            
            self.lblTitle.text = "תשלום";
            var original = response
            
            //            original = "http://109.226.9.246/payment.html"
            if let encoded = (original as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                
                let url = URL(string: encoded) {
                let urlReq : URLRequest = URLRequest.init(url:url)
                self.webView.loadRequest(urlReq)
            }
        }
    }
    
    func loadPaymentHistoryapi(paymentId: String, isSaveCard : Bool){
        self.startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        Manager.sharedManager().loadPaymenthistory(block: { (response, errorMessage) -> (Void) in
            self.paymentDiposite_number = paymentId;
            self.stopAnimating()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
            controller.diposite_number = self.paymentDiposite_number;
            self.navigationController?.pushViewController(controller, animated: true)
        })
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("Loading")
        self.stopAnimating()
        if let text = webView.request?.url?.absoluteString{
            print(text)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let strSuccess = "\(kBaseUrl)\(kPaymentUrl)paymentsuccessnew" //"http://109.237.25.22:3051/api/payments/paymentsuccess"
            let strFail = "\(kBaseUrl)\(kPaymentUrl)paymentfailnew" //"http://109.237.25.22:3051/api/payments/paymentfail"
            if(text.contains("paymentsuccessnew")){
                 self.loadPaymentHistoryapi(paymentId: self.paymentDiposite_number, isSaveCard: false)
            } else if(text.contains("paymentfailnew")){
                let controller = storyBoard.instantiateViewController(withIdentifier: "ThankYou2VC") as! ThankYou2VC
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
//            if(text == strSuccess){
//                self.loadPaymentHistoryapi(paymentId: self.paymentDiposite_number, isSaveCard: false)
////                let message  = "האם ברצונך לשמור מספר כרטיס אשראי?"
////                let alert = UIAlertController.init(title: "", message:message, preferredStyle: .alert)
////                let approveAction = UIAlertAction.init(title: "כן", style: .default) { (action) in
////                    self.updateSaveCardStatusApi()
////
////                }
////                let decilneAction = UIAlertAction.init(title: "לא", style: .default) { (action) in
////                    self.loadPaymentHistoryapi(paymentId: self.paymentDiposite_number, isSaveCard: false)
////                }
////                alert.addAction(decilneAction)
////                alert.addAction(approveAction)
////                self.present(alert, animated: true, completion: nil)
////                return;
//
//            } else if(text == strFail){
//                let controller = storyBoard.instantiateViewController(withIdentifier: "ThankYou2VC") as! ThankYou2VC
//                self.navigationController?.pushViewController(controller, animated: true)
//            }
        }
    }
    
    func updateSaveCardStatusApi() {
        self.startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        Manager.sharedManager().saveCard(paymentId: self.paymentDiposite_number, pay_type: "1") { (result, message) -> (Void) in
            self.loadPaymentHistoryapi(paymentId: self.paymentDiposite_number, isSaveCard: false)
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        Utils.showAlert(withMessage: error.localizedDescription)
        self.stopAnimating()
    }
    
    @IBAction func contactClicked(_ sender: Any) {
        if(AccountManager.instance().activeAccount != nil){
            let controller = MyContactsVC.initViewController(isFromHome: false)
            controller.isFrom = "pay2"
            controller.delegate = self
            controller.isFromAddDebit = true
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            let loginController = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let nav = UINavigationController.init(rootViewController: loginController)
            self.navigationController?.present(nav, animated: true, completion: nil)
        }
    }
}
