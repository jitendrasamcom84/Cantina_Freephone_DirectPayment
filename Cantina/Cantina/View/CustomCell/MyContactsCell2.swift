import UIKit

class MyContactsCell2: UITableViewCell {
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var btnMobile: UIButton!
    @IBOutlet weak var btnStore: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(reveiver:Receiver)  {
        
        lbl1.text = reveiver.receiver_name
        lbl3.text = "מס’ חשבון: \(reveiver.receiver_id ?? "")"
        
        if(reveiver.paymentid == nil){
            lbl4.text = "טרם בוצעה הפקדה"
        }else {
            
            if(reveiver.paymenttype == "0"){
                lbl4.text = "מס׳ הפקדה לקנטינה: " + String(describing: reveiver.paymentid!)
            }else{
                lbl4.text = "מס׳ הפקדה לפרי-פון: " + String(describing: reveiver.paymentid!)
            }
        }
        
        
        if reveiver.amount != nil {
            lbl5.text = "סכום ההפקדה:" + "₪" + String(describing: reveiver.amount!)
        }else{
            lbl5.text = "סכום ההפקדה:" + "₪" + "0"
        }
    
        lbl5.isHidden = false
        if(reveiver.paymentid == nil){
            
            lbl5.isHidden = true
        }
        
        
        self.lbl5.needsUpdateConstraints()
        self.lbl5.layoutIfNeeded()
        self.contentView.needsUpdateConstraints()
        self.contentView.layoutIfNeeded()
        self.needsUpdateConstraints()
        self.layoutIfNeeded()
    }
    
    
    func setDataShowbutton(reveiver:Receiver)  {
        
        lbl1.text = reveiver.receiver_name
        lbl3.text = "מס’ חשבון: \(reveiver.receiver_id ?? "")"
        
        if(reveiver.paymentid == nil){
          //  lbl4.text = "טרם בוצעה הפקדה"
        }else {
            
            if(reveiver.paymenttype == "0"){
              //  lbl4.text = "מס׳ הפקדה לקנטינה: " + String(describing: reveiver.paymentid!)
            }else{
//                lbl4.text = "מס׳ הפקדה לפרי-פון: " + String(describing: reveiver.paymentid!)
            }
        }
        if reveiver.amount != nil {
//            lbl5.text = "סכום ההפקדה:" + "₪" + String(describing: reveiver.amount!)
        }else{
//            lbl5.text = "סכום ההפקדה: " + "₪" + "0"
        }
        
        //        lblHeightConstrainsts.constant = 19
        lbl5.isHidden = false
        if(reveiver.paymentid == nil){
            //            lblHeightConstrainsts.constant = 0
            lbl5.isHidden = true
        }
        
        self.lbl5.needsUpdateConstraints()
        self.lbl5.layoutIfNeeded()
        self.contentView.needsUpdateConstraints()
        self.contentView.layoutIfNeeded()
        self.needsUpdateConstraints()
        self.layoutIfNeeded()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
