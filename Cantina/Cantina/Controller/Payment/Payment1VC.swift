import UIKit

class Payment1VC: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet var btnDot: UIButton!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var btnDigits: [UIButton]!
    
    //MARK:- Properties
    var isFromHome : Bool = false
    var btnValue = String()
    var Amount = String()
    var appends = 0
    var isFromReceiverPage : Bool = false
    var receiver : Receiver = Receiver()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSubmit.isEnabled = true
        btnSubmit.alpha = 0.3
        btnSubmit.isUserInteractionEnabled = true
    }
    
    //MARK:- IB Actions
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        let name: String = lblAmount.text!
        var truncated = name.substring(to: name.index(before: name.endIndex))
        if truncated == "" || truncated  == "₪0" || truncated  == "₪" {
            truncated  = "₪0"
        }
        lblAmount.text = truncated
        if lblAmount.text == "₪0"
        {
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
    
    @IBAction func btnSubmitClicked(_ sender: Any){
        var amount = lblAmount.text?.replacingOccurrences(of: "₪", with: "")
        let  castAmount : Float = Float(amount!)!
        if(castAmount <= 0){
            Utils.showAlert(withTitle: tMissingItems, withMessage: "הזן סכום חוקי", withButtonTitle:tApproval.localized)
            return;
        }
        let account = AccountManager.instance().activeAccount
        if account != nil{
            Manager.sharedManager().loadCommission(amount: lblAmount.text!) { (response, errorMessage) -> (Void) in
                if errorMessage.count > 0{
                    Utils.showAlert(withMessage: errorMessage)
                    return
                }
                let vc = Payment2VC.initViewController(contact: self.receiver)

                vc.passAmount = self.lblAmount.text!
                let a = String(describing: response)

                let b = Float(a)
                let c = Float(amount!)
                let d : Float = b! + c!
                amount = "₪" + String(d)

                vc.btnHome = self.btnValue

                if self.isFromReceiverPage == true{
                    self.receiver.commission = b! as NSNumber
                    self.receiver.amount = c! as NSNumber
                    self.receiver.total_amout = d as NSNumber

                    vc.commissionAmount = String(describing: self.receiver.commission!)
                    let r_amount_commision = Float(c!) + Float(truncating: self.receiver.commission!)
                    vc.amountWithCommission = String(r_amount_commision)
                }

                vc.commissionAmount = a
                vc.amountWithCommission = amount!
                vc.totalAmount = self.lblAmount.text!
                vc.receiver = self.receiver
                vc.isFromHome = self.isFromHome
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            let loginController = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let nav = UINavigationController.init(rootViewController: loginController)
            self.navigationController?.present(nav, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pay12" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Payment2VC") as! Payment2VC
            vc.btnHome = btnValue
            vc.passAmount = lblAmount.text!
            vc.receiver = receiver
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
