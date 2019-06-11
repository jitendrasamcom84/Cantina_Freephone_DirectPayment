
import UIKit
import NVActivityIndicatorView

@objc protocol MyContactsVCDelegate {
    func selectedContact(contact:Receiver)
}

class MyContactsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,NVActivityIndicatorViewable {
    
    @IBOutlet weak var tblContacts: UITableView!
    var delegate :  MyContactsVCDelegate? = nil
    var contactArray = [Receiver]()
    var isFrom = String()
    
    var isFromAddDebit : Bool = false
    
    class func initViewController(isFromHome: Bool) -> MyContactsVC {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "MyContactsVC") as! MyContactsVC
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblContacts.tableFooterView = UIView()
        tblContacts?.register(UINib(nibName: "MyContactsCell2", bundle: nil), forCellReuseIdentifier: "MyContactsCell2")
        tblContacts?.register(UINib(nibName: "MyContactTwoButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "MyContactTwoButtonTableViewCell")
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadContactsApi), name: NSNotification.Name(rawValue: kLoadConatcts), object: nil)
        
        if(AccountManager.instance().activeAccount != nil){
            startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
            loadContactsApi()
        }else{
            Utils.showAlert(withMessage: "Unauthorized Request, Please sign in first.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(AccountManager.instance().activeAccount != nil){
            self.contactArray = Receiver.getAll()
            self.tblContacts.reloadData()
        }
    }
    
    @objc func loadContactsApi ()  {
        Manager.sharedManager().getCantinaAndFreePhoneUserList { (result, errorMessage) -> (Void) in
            self.stopAnimating()
            if(errorMessage.count > 0){
                Utils.showAlert(withMessage: errorMessage)
            }else{
                self.contactArray = Receiver.getAll()
                self.tblContacts.reloadData()
            }
        }
    
//        Manager.sharedManager().loadMyContacts { (result, errorMessage) -> (Void) in
//            self.stopAnimating()
//            if(errorMessage.count > 0){
//                Utils.showAlert(withMessage: errorMessage)
//            }else{
//                self.contactArray = Receiver.getAll()
//                self.tblContacts.reloadData()
//            }
//        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addContactClicked(_ sender: Any) {
        let controller = AddNewContactVC.initViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: TableView Method
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblContacts.dequeueReusableCell(withIdentifier: "MyContactsCell") as! MyContactsCell
        
        cell.selectionStyle = .none
        
        let contact: Receiver = contactArray[indexPath.row]
        cell.setData(receiver: contact)
        cell.btnEdit.tag = indexPath.row
        cell.btnDepositCantina.tag = indexPath.row
        cell.btnDepositFreePhone.tag = indexPath.row
        
        if contact.receiver_id == nil {
            cell.btnDepositCantina.isHidden = true
        }
        else{
            cell.btnDepositCantina.isHidden = false
        }
        
        if contact.main_free_user_id == nil {
            cell.btnDepositFreePhone.isHidden = true
        }
        else{
            cell.btnDepositFreePhone.isHidden = false
        }
        
        cell.btnEdit.addTarget(self, action: #selector(MyContactsVC.editClicked(_:)), for: .touchUpInside)
        cell.btnDepositCantina.addTarget(self, action: #selector(MyContactsVC.depositCantinaClicked(_:)), for: .touchUpInside)
        cell.btnDepositFreePhone.addTarget(self, action: #selector(MyContactsVC.depositFreephoneClicked(_:)), for: .touchUpInside)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblContacts.deselectRow(at: indexPath, animated: true)
        if(contactArray.count > 0){
            let selectedContact = contactArray[indexPath.row]
            if (isFrom == "pay2"){
                if(delegate != nil){
                    delegate?.selectedContact(contact: selectedContact)
                    self.navigationController?.popViewController(animated: true)
                }
            } else{
                let controller = ContactDetailVC.initViewController(contact: selectedContact)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    @objc func editClicked(_ sender: UIButton) {
        let selectedContact = contactArray[sender.tag]
        let controller = ContactDetailVC.initViewController(contact: selectedContact)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func depositCantinaClicked(_ sender : UIButton){
        Utils.setBoolForKey(false, key: isFreePhoneNewUser)
        Utils.setStringForKey("0", key: kPaymentType)
        let receiver : Receiver = contactArray[sender.tag]
        if receiver.paymentid == nil {
            if (isFrom == "pay2"){
                if(delegate != nil){
                    delegate?.selectedContact(contact: receiver)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "Payment1VC") as! Payment1VC
                vc.isFromReceiverPage = true
                vc.receiver = receiver
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "Payment2VC") as! Payment2VC
            vc.receiver = receiver
            vc.commissionAmount = String(describing: receiver.commission!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func depositFreephoneClicked(_ sender : UIButton){
        Utils.setBoolForKey(false, key: isFreePhoneNewUser)
        Utils.showAlert(withMessage: "מצטערים השרות אינו זמין כעת נחזור בקרוב")
//        let receiver : Receiver = contactArray[sender.tag]
//        let controller = FreePhoneEnteringAmountVC.initViewController(user: receiver)
//        controller.id = receiver.entity_id!
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

