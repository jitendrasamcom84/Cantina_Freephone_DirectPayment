
import UIKit
import NVActivityIndicatorView
import ActionSheetPicker_3_0
import MagicalRecord
import FastEasyMapping

@objc protocol DebitEditVCVCDelegate {
    func popView(strDebitId: String)
}

class DebitEditVC: BaseViewController, MyContactsVCDelegate,  NVActivityIndicatorViewable , UITextFieldDelegate {
    
    var delegate :  DebitEditVCVCDelegate? = nil
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnTermsText: UIButton!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var btnCantina: UIButton!
    @IBOutlet var btnUser: UIButton!
    @IBOutlet var txtAmount: UITextField!
    var total_Amount: Float = 0.0
    @IBOutlet var txtDate: UITextField!
    @IBOutlet var mainView: UIView!
    var paymentId = String()
    var local_paymentId = String()
    var isPayment = Bool()
    var isEdited = Bool()
    var debit = DebitList()
    var paymentType : String = ""
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var lblCommission: UILabel!
    var calculation_Array = [CommissionCalculation]()
    
    class func initViewController(debit:DebitList, isEdited: Bool) -> DebitEditVC {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DebitEditVC") as! DebitEditVC
        controller.debit = debit
        controller.isEdited = isEdited
        return controller
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtDate.text = "2"
         getCalculateCommission()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        local_paymentId = paymentId
        Manager.sharedManager().loadTranzilaTokenForDebit { (result, errorMessage) -> (Void) in
        }
        txtAmount.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtAmount.delegate = self
        self.cantinaClicked(UIButton())
        if(isEdited == true){
            showData()
        }else{
            if(isPayment == true){
                showPaymentData()
            }
        }
        if(isEdited == true){
            btnSubmit.setTitle("סיים", for: .normal)
        }else{
            btnSubmit.setTitle("המשך", for: .normal)
        }
        self.submitButtonVisibility()
        btnTerms.isSelected = false
       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.submitButtonVisibility();
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        var str = ""
        str = (textField.text?.replacingOccurrences(of: "₪", with: ""))!
        textField.text = "₪\(str )"
        calculateCommission(txt: str)
    }
    
    func submitButtonVisibility(){
        let FirstName = txtFirstName.text!.trimmingCharacters(in: .whitespaces)
        let LastName = txtLastName.text!.trimmingCharacters(in: .whitespaces)
        var Amount = txtAmount.text!.trimmingCharacters(in: .whitespaces)
        Amount = Amount.replacingOccurrences(of: "₪", with: "")
        if Amount.count == 0 {
            Amount = "0"
        }
        let amountFloat  : Float = Float(Amount)!
        btnSubmit.alpha = 0.3;
        btnSubmit.isUserInteractionEnabled = false
        if btnTerms.isHidden {
            if FirstName.count > 0 && LastName.count > 0 && amountFloat > 0{
                btnSubmit.alpha = 1;
                btnSubmit.isUserInteractionEnabled = true
            }
        }else{
            if FirstName.count > 0 && LastName.count > 0 && amountFloat > 0 && btnTerms.isSelected{
                btnSubmit.alpha = 1;
                btnSubmit.isUserInteractionEnabled = true
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.scroll.frame = CGRect(x:self.scroll.frame.origin.x ,y:self.scroll.frame.origin.y ,width:self.scroll.frame.size.width ,height:self.view.frame.size.height )
        self.scroll.contentSize = CGSize(width: self.scroll.frame.size.width, height: self.btnSubmit.frame.origin.y + self.btnSubmit.frame.size.height + self.imgHeader.frame.size.height + 5 )
    }
    
    func showPaymentData()  {
        let payment =  Payment.getbyId(pId: paymentId);
        
        txtFirstName.text = payment.receiver_name;
        lblTitle.text = payment.receiver_name;
        txtLastName.text = payment.receiver_id;
        if Utils.fetchString(forKey: kPaymentType) == "0" {
            paymentType = "0"
        }else{
            paymentType = "1"
        }
        let price = String(describing: payment.amount!)
        txtAmount.text = "₪" + price
    }
    
    func showData()  {
        if(isEdited == true){
            btnSubmit.setTitle("סיים", for: .normal)
            lblTerms.isHidden = true
            btnTerms.isHidden = true
            btnTermsText.isHidden = true
        }else{
            btnSubmit.setTitle("המשך", for: .normal)
            lblTerms.isHidden = false
            btnTerms.isHidden = false
            btnTermsText.isHidden = false
        }
        if(debit.payment_type == 1){
        }else{
        }
        txtFirstName.text = debit.receiver_name
        lblTitle.text = debit.receiver_name;
        txtLastName.text  = debit.receiver_id
        txtAmount.text = "₪\(String(describing: debit.amount!))"
        txtDate.text = String(describing: debit.date!)
        paymentType =  String(describing: debit.payment_type!)
    }
    
    @IBAction func contactsClicked(_ sender: Any) {
        let controller = MyContactsVC.initViewController(isFromHome: false)
        controller.delegate = self
        controller.isFrom = "pay2"
        controller.isFromAddDebit = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnBackClicked(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func userClicked(_ sender: Any) {
        paymentType = "1"
        self.submitButtonVisibility();
    }
    
    @IBAction func cantinaClicked(_ sender: Any) {
        paymentType = "0"
        self.submitButtonVisibility();
    }
    
    @IBAction func termConditionClicked(_ sender : Any){
        if btnTerms.isSelected {
            btnTerms.isSelected = false
        }else{
            btnTerms.isSelected = true
        }
        self.submitButtonVisibility();
    }
    
    @IBAction func dateSelectClicked(_ sender : Any){
     
        ActionSheetStringPicker.show(withTitle: "בחר תאריך", rows: ["2","5","8","10"], initialSelection: 0, doneBlock: { (picker, selectedIndex, selectedValue) in
            self.txtDate.text = selectedValue as? String;
        }, cancel: { (picker) in
            
        }, origin: sender)
    }
    
    @IBAction func termConditionTextClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsOfUseVC") as!  TermsOfUseVC
        vc.isFromDebitList = true
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        let strFirstName = txtFirstName.text!.trimmingCharacters(in: .whitespaces)
        let strLastName = txtLastName.text!.trimmingCharacters(in: .whitespaces)
        let strAmount = txtAmount.text!.trimmingCharacters(in: .whitespaces)
        let strDate = txtDate.text!.trimmingCharacters(in: .whitespaces)
        let amount = strAmount.replacingOccurrences(of: "₪", with: "")
        var amountFloat : Float = 0.0
        if amount.count != 0 {
            amountFloat = Float(amount)!
        }
        if (strFirstName.count <= 0){
            Utils.showAlert(withTitle: tMissingItems, withMessage: "נא להזין שם מלא!", withButtonTitle:tApproval.localized)
        } else if (strLastName.count <= 0){
            Utils.showAlert(withTitle: tMissingItems, withMessage: "הזן מספר חשבון!", withButtonTitle:tApproval.localized)
        } else if (paymentType == ""){
            Utils.showAlert(withTitle: tMissingItems, withMessage: "נא להזין את שמךבחר סוג תשלום!", withButtonTitle:tApproval.localized)
        } else if (strAmount.count <= 0){
            Utils.showAlert(withTitle: tMissingItems, withMessage: "הזן מספר חשבון!", withButtonTitle:tApproval.localized)
        }else if (strDate.count <= 0){
            Utils.showAlert(withTitle: tMissingItems, withMessage: "אנא הזן תאריך", withButtonTitle:tApproval.localized)
        }else if(amountFloat <= 0){
            Utils.showAlert(withTitle: tMissingItems, withMessage: "הזן סכום חוקי", withButtonTitle:tApproval.localized)
        }else{

            if(isEdited == true){
                debit.receiver_name = txtFirstName.text
                debit.receiver_id = txtLastName.text
                debit.payment_type = Int(paymentType)! as NSNumber
                if(strAmount.contains("₪")){
                    let strAmountArray:[String] = strAmount.components(separatedBy: "₪")
                    if let amountValue = Float(strAmountArray[1]) {
                        debit.amount = amountValue as NSNumber
                    }
                }else{
                    if let amountValue = Float(strAmount) {
                        debit.amount = amountValue as NSNumber
                    }
                }
                debit.date = Int(strDate)! as NSNumber
                getCommision(debit: debit)
            } else{
                debit = DebitList.createEntity();
                debit.receiver_name = txtFirstName.text
                debit.receiver_id = txtLastName.text
                debit.payment_type = Int(paymentType)! as NSNumber
                if(strAmount.contains("₪")){
                    let strAmountArray:[String] = strAmount.components(separatedBy: "₪")                    
                    if let amountValue = Float(strAmountArray[1]) {
                        debit.amount = amountValue as NSNumber
                    }
                }else{
                    if let amountValue = Float(strAmount) {
                        debit.amount = amountValue as NSNumber
                    }
                }
                debit.date = Int(strDate)! as NSNumber
                debit.saveEntity()
                getCommision(debit: debit)
            }
        }
    }
    
    
    func getCommision(debit:DebitList) {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        Manager.sharedManager().loadCommission(amount: (debit.amount?.stringValue)!) { (response, errorMessage) -> (Void) in
            self.stopAnimating()
            if errorMessage.count > 0{
                Utils.showAlert(withMessage: errorMessage)
                return
            }
            
            if(self.isEdited == true){
                self.editDebitListApi(debit: debit)
            }else{
                let c_amount : Float = response as! Float
                let t_amount : Float = c_amount  + (debit.amount?.floatValue)!
                debit.commission = NSNumber.init(value: c_amount)
                debit.total_amount = NSNumber.init(value: t_amount)
                self.total_Amount = t_amount
                self.addDebitListApi(debit: debit)
            }
        }
    }
    
    func editDebitListApi(debit:DebitList)  {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        debit.editdebitList { (respose, errorMessage) -> (Void) in
            self.stopAnimating()
            if(errorMessage.count > 0){
                Utils.showAlert(withMessage: errorMessage)
            }else{
                debit.saveEntity()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLoadDebitListNotification), object: nil)
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: DebitListVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
    }

    
   
    
    func addDebitListApi(debit:DebitList)  {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        Utils.setStringForKey(String(describing: debit.payment_type!), key: kPaymentType)
        
        debit.addDebit { (respose, errorMessage) -> (Void) in
            self.local_paymentId = respose as! String
            self.stopAnimating()
            debit.mr_deleteEntity()
            debit.saveEntity()
            
            let arr : [TranzilaToken] = TranzilaToken.getAll()
            
            self.sendDebitPaymentApi(paymentId: self.local_paymentId, is_save_card: "0")
            
//            if(arr.count > 0){
//                let tokenObject : TranzilaToken = arr[0]
//                let lastFourDigit = tokenObject.card
//                let message  = "האם ברצונך לבצע תשלום עם כרטיס המסתיים ב " + lastFourDigit!
//                
//                let alert = UIAlertController.init(title: "", message:message, preferredStyle: .alert)
//                
//                let approveAction = UIAlertAction.init(title: "אישור", style: .default) { (action) in
//                    self.sendDebitPaymentApiTranzilaToken(token: tokenObject.token!, expDate: tokenObject.expdate!, paymentId:  respose as! String)
//                }
//                let decilneAction = UIAlertAction.init(title: "שלם עם כרטיס אחר", style: .default) { (action) in
//                    self.sendDebitPaymentApi(paymentId: self.local_paymentId, is_save_card: "0")
//                }
//                alert.addAction(decilneAction)
//                alert.addAction(approveAction)
//                self.present(alert, animated: true, completion: nil)
//                return;
//                
//            }else{
//                self.sendDebitPaymentApi(paymentId: self.local_paymentId, is_save_card: "0")
//            }
//            self.sendDebitPaymentApi(paymentId: self.local_paymentId, is_save_card: "0")
            

            

        }
    }
    
    func sendDebitPaymentApiTranzilaToken(token: String , expDate : String , paymentId : String) {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        // MARK :: Sending paymentid , token , expDate for the token payment
        Manager.sharedManager().sendDebitPaymentTranzilaToken(paymentId: paymentId ,token: token, expDate: expDate) { (response, errorMessage) -> (Void) in
            self.stopAnimating()
            if errorMessage.count > 0{
                let controller = storyBoard.instantiateViewController(withIdentifier: "ThankYou2VC") as! ThankYou2VC
                self.navigationController?.pushViewController(controller, animated: true)
                return
            }
            self.loadDebitList(responseId: paymentId)
        }
    }
    func sendDebitPaymentApi(paymentId: String , is_save_card : String) {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        Manager.sharedManager().sendDebitPayment(paymentId: paymentId, is_save_card: "0") { (response, errorMessage) -> (Void) in
            if errorMessage.count > 0{
                Utils.showAlert(withMessage: errorMessage)
                return
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebitPaymentViewController") as! DebitPaymentViewController
            vc.debitId = paymentId
//            vc.amount = self.txtAmount.text!
            vc.amount = "₪\(String(describing: self.total_Amount))"
            vc.webUrl = response as! String
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func loadDebitList(responseId : String){
        Manager.sharedManager().loadDebitList { (reult, error) -> (Void) in
            self.stopAnimating()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
            vc.isFromDebit = true
            vc.diposite_number = responseId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getCalculateCommission() {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        Manager.sharedManager().loadCalculationCommission { (result, error) -> (Void) in
            self.stopAnimating()
            self.myTextFieldDidChange(self.txtAmount)
        }
    }
    
    func calculateCommission(txt : String) {
        let commission : CommissionCalculation = CommissionCalculation.getFirst()
        let x = commission.x?.intValue
        let y = commission.y?.intValue
        var f = Int(txt)
        if (f == nil) {
            f = 0
        }
        var s = commission.s?.intValue
        let z1 = commission.z1?.intValue
        let z2 = commission.z2?.intValue
        
        s = y!+(x!*f!)/100
        
        if (s! < z1!) {
            self.updateCommission(commissionAmount:z1!)
        }
        else if (s!>z2!){
            self.updateCommission(commissionAmount:z2!)
        }
        else{
            self.updateCommission(commissionAmount:s!)
        }
    }
    
    func updateCommission(commissionAmount : Int) {
        if (txtAmount.text?.count)! == 1 {
            lblCommission.text = "בכל פעם תחויב בעמלה בסך ₪0.0 שקלים"
        }
        else{
         lblCommission.text = "בכל פעם תחויב בעמלה בסך ₪ \(Utils.getFractionPart(amount: String(commissionAmount))) שקלים"
        }
    }
    
    
    //MARK: MyContactsVCDelegate
    func selectedContact(contact: Receiver) {
        txtFirstName.text = contact.receiver_name
        lblTitle.text = contact.receiver_name;
        txtLastName.text  = contact.receiver_id
        self.submitButtonVisibility();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }    
}
