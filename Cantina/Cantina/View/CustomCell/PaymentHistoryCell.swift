import UIKit

class PaymentHistoryCell: UITableViewCell {
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblStatus: UILabel!
    
    @IBOutlet var lblReceiverName: UILabel!
    @IBOutlet var lblAccountNumber: UILabel!
    @IBOutlet var lblDepositNumber: UILabel!
    @IBOutlet var lblDepositAmount: UILabel!
    @IBOutlet var lblCommission: UILabel!
    
    @IBOutlet var btnTypeStatus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(payment:Payment)  {
        //Date
        lblDate.text = DateUtils.getDateStringddMyyWithFormat(date: payment.dateAdded!)
        
        if payment.payment_type == "0" {
            //Cantina
//            Receiver Name
            if payment.rec_id?.receiver_name != nil{
                lblReceiverName.text = "הפקדה לחשבון קנטינה: " + (payment.rec_id?.receiver_name)!
            }
            
            //Account Number
            if payment.rec_id?.receiver_id != nil{
                lblAccountNumber.text = "מס’ חשבון: " + ((payment.rec_id?.receiver_id!)!)
            }
            
            //Deposit Number
            lblDepositNumber.text = "מספר הפקדה: \(String(describing: payment.paymentid!))"
            
            //Status
            btnTypeStatus.setTitle("הפקד שוב", for: .normal)
            btnTypeStatus.setImage(UIImage.init(named: "store"), for: .normal)
            
            //Deposit Amount
            lblDepositAmount.text = "סכום ההפקדה:  ₪\(String(describing: payment.amount!))"
        }
        else {
            //FreePhone
//            Receiver Name
            if payment.rec_id?.receiver_name != nil{
                lblReceiverName.text = "הטענה לחשבון פריפון: " + (payment.rec_id?.receiver_name)!
            }
            
            //Account Number
            if payment.rec_id?.free_user_id != nil{
                lblAccountNumber.text = "מס’ משתמש: " + ((payment.rec_id?.free_user_id)!)
            }
            
            //Deposit Number
            lblDepositNumber.text = "מספר הטענה: \(String(describing: payment.paymentid!))"
            
            //Status
            btnTypeStatus.setTitle("הטען שוב", for: .normal)
            btnTypeStatus.setImage(UIImage.init(named: "payment"), for: .normal)
            
            //Deposit Amount
            lblDepositAmount.text = "סכום ההטענה:  ₪\(String(describing: payment.amount!))"
        }
        
        //Commission
        let commission : Float = Float(payment.total_amount!) - Float(payment.amount!)
        lblCommission.text = "בתוספת עמלה: ₪\(Utils.getFractionPart(amount: String(describing: commission)))"
        
//        //Receiver Name
//        if payment.rec_id?.receiver_name != nil{
//            lblReceiverName.text = "הפקדה לחשבון קנטינה: " + (payment.rec_id?.receiver_name)!
//        }
//
//        //Account Number
//        if payment.rec_id?.entity_id != nil{
//            lblAccountNumber.text = "מס’ חשבון: " + ((payment.rec_id?.entity_id!)!)
//        }
//
//
//        //Deposit Number
//        if(payment.payment_type == "0"){
//            // MARK :: Home
//            lblDepositNumber.text = "מספר הפקדה: \(String(describing: payment.paymentid!))"
//            btnTypeStatus.setImage(UIImage.init(named: "store"), for: .normal)
//        }else{
//            // MARK :: Card
//            lblDepositNumber.text = "מספר הפקדה: \(String(describing: payment.paymentid!))"
//            btnTypeStatus.setImage(UIImage.init(named: "payment"), for: .normal)
//        }
//
//        //Deposit Amount
//        lblDepositAmount.text = "סכום ההפקדה:  ₪\(String(describing: payment.amount!))"
//
        
        
        //Status
        if payment.status == 0 {
            // MARK ::"Status: Pending"
            lblStatus.text = "סטטוס: בהמתנה"
        }else{
            // MARK ::"Status: Approved"
            lblStatus.text = "סטטוס: בוצע"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
