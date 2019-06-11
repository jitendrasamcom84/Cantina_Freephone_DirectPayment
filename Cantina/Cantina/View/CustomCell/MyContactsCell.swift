import UIKit

class MyContactsCell: UITableViewCell {
    
    @IBOutlet weak var lblRecipientName: UILabel!
    @IBOutlet weak var lblCantinaAccountNumber: UILabel!
    @IBOutlet weak var lblFreephoneUserId: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDepositCantina: UIButton!
    @IBOutlet weak var btnDepositFreePhone: UIButton!
    
    @IBOutlet weak var lbl4Height: NSLayoutConstraint!
    @IBOutlet weak var lbl5Height: NSLayoutConstraint!
    @IBOutlet weak var btnPhoneHeight: NSLayoutConstraint!
    @IBOutlet weak var btnStoreHeight: NSLayoutConstraint!
    @IBOutlet weak var btnArrowHeight: NSLayoutConstraint!
    @IBOutlet weak var btnPhoneTop: NSLayoutConstraint!
    @IBOutlet weak var btnPhoneBottom: NSLayoutConstraint!
    @IBOutlet weak var lbl5TOp: NSLayoutConstraint!
    @IBOutlet weak var lbl4Top: NSLayoutConstraint!
    @IBOutlet var lblHeightConstrainsts: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(receiver:Receiver) {
        lblRecipientName.text = receiver.receiver_name
        lblCantinaAccountNumber.text = "מס’ חשבון קנטינה: \(receiver.receiver_id ?? "")"
        lblFreephoneUserId.text = "מס׳ משתמש פריפון: \(receiver.free_user_id ?? "")"
    }
}
