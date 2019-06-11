import UIKit

class ThankYouVC: BaseViewController, UIScrollViewDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var lblAmount_Sum: UILabel!
    @IBOutlet weak var lblCommission_Amount: UILabel!
    @IBOutlet weak var lblTotal_Sum: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnDeposite: UIButton!
    
    //MARK:- Properties
    var debitObject = DebitList()
    var isFromDebit : Bool = false
    var diposite_number  = String();
    
    //MARK:- Add Values for commission and amount
    var enteredAmount = Float()
    var commissionAmount = Float()
    
    
    //MARK:- Initializer
    class func initViewController() -> ThankYouVC {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
        return controller
    }
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:- IBActions
    @IBAction func debitClicked(_ sender: UIButton) {
        let controller = DebitEditVC.initViewController(debit: self.debitObject, isEdited: false)
        controller.paymentId  = diposite_number;
        controller.isPayment = true
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func HomeClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: Custom Method To Set Data
extension ThankYouVC {
    func setUpView() {
        if (self.view.frame.size.height <= 568){
            scrollView.isScrollEnabled = true
        }
        else{
            scrollView.isScrollEnabled = false
        }
    }
    
    func setData() {
        if isFromDebit{
            btnDeposite.isHidden = true
//            let debit = DebitList.getbyId(id: diposite_number)
//            self.debitObject = debit;
            
            //Amount
            let Deposit : Float = (enteredAmount)
            let strAmount = "סכום הפקדה : ₪"
            self.lblAmount_Sum.text =  "\(strAmount)\(Utils.getFractionPart(amount: String(Deposit)))"
//            let Deposit : Float = (debit.amount?.floatValue)!
//            let strAmount = "סכום הפקדה : ₪"
//            self.lblAmount_Sum.text =  "\(strAmount)\(Utils.getFractionPart(amount: String(Deposit)))"
            
            //Commission
            let Commission : Float = (commissionAmount)
            let strCommission = "סכום עמלה :"
            self.lblCommission_Amount.text =  "\(strCommission)\(Utils.getFractionPart(amount: "₪" + String(Commission)))"
            
//            let Commission : Float = (debit.commission?.floatValue)!
//            let strCommission = "סכום עמלה :"
//            self.lblCommission_Amount.text =  "\(strCommission)\(Utils.getFractionPart(amount: "₪" + String(Commission)))"
            
            //commission + deposit = Total
            let sum : Float = (enteredAmount) + (commissionAmount)
            let strTotal = "סכום להעברה :"
            self.lblTotal_Sum.text =  "\(strTotal)\(Utils.getFractionPart(amount: "₪" + String(sum)))"
//            let sum : Float = (debit.amount?.floatValue)! + (debit.commission?.floatValue)!
//            let strTotal = "סכום לחיוב :"
//            self.lblTotal_Sum.text =  "\(strTotal)\(Utils.getFractionPart(amount: "₪" + String(sum)))"
        } else{
            btnDeposite.isHidden = false
//            let payment = Payment.getbyId(pId: diposite_number)
            
            //Amount
            let Deposit : Float = (enteredAmount)
            let strAmount = "סכום הפקדה : ₪"
            self.lblAmount_Sum.text =  "\(strAmount)\(Utils.getFractionPart(amount: String(Deposit)))"
//            let Deposit : Float = (payment.amount?.floatValue)!
//            let strAmount =  "סכום הפקדה : ₪"
//            self.lblAmount_Sum.text =  "\(strAmount)\(Utils.getFractionPart(amount: String(Deposit)))"
            
            //Commission
            let Commission : Float = (commissionAmount)
            let strCommission = "סכום עמלה :"
            self.lblCommission_Amount.text =  "\(strCommission)\(Utils.getFractionPart(amount: "₪" + String(Commission)))"
//            let Commission : Float = (payment.commission?.floatValue)!
//            let strCommission = "סכום עמלה :"
//            self.lblCommission_Amount.text =  "\(strCommission)\(Utils.getFractionPart(amount: "₪" + String(Commission)))"
            
            //commission + deposit = Total
            let sum : Float = (enteredAmount) + (commissionAmount)
            let strTotal = "סכום להעברה :"
            self.lblTotal_Sum.text =  "\(strTotal)\(Utils.getFractionPart(amount: "₪" + String(sum)))"
//            let sum : Float = (payment.amount?.floatValue)! + (payment.commission?.floatValue)!
//            let strTotal = "סכום לחיוב :"
//            self.lblTotal_Sum.text =  "\(strTotal)\(Utils.getFractionPart(amount: "₪" + String(sum)))"
        }
    }
}

//MARK: Custom Method To Change Text Style Format
extension ThankYouVC {
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
}

//MARK: DebitEditVCVCDelegate
extension ThankYouVC : DebitEditVCVCDelegate {
    func popView(strDebitId: String) {
        btnDeposite.isHidden = true
    }
}
