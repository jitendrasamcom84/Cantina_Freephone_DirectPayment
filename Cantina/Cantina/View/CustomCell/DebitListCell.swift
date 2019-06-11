import UIKit

class DebitListCell: UITableViewCell {
    
    @IBOutlet var lblFirstName: UILabel!
    @IBOutlet var lblLastName: UILabel!
    @IBOutlet var lblAccountNum: UILabel!
    @IBOutlet var lblDepositeAmount: UILabel!
    @IBOutlet var depositeDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(debit:DebitList)  {
        lblFirstName.text = debit.receiver_name
        lblLastName.text = debit.receiver_name
        lblAccountNum.text = "מס’ חשבון: \(debit.receiver_id ?? "")"
        if debit.amount != nil {
            lblDepositeAmount.text = "סכום ההפקדה: ₪\(String(describing: debit.amount!))"
        }
        if debit.payment_type == 0 {
            depositeDate.text = "תאריך להפקדה לקנטינה: \(String(describing: debit.date!)) לחודש"
        }else{
            depositeDate.text = "תאריך להפקדה לפרי-פון: \(String(describing: debit.date!)) לחודש"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
