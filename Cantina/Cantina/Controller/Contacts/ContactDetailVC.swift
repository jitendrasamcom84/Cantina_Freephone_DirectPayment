
import UIKit
import NVActivityIndicatorView

class ContactDetailVC: BaseViewController, NVActivityIndicatorViewable {
    var contact = Receiver()
    @IBOutlet weak var txtFirstName: customTextField!
    @IBOutlet weak var txtLastName: customTextField!
    @IBOutlet weak var txtCanteenAccountNumber: customTextField!
    @IBOutlet weak var txtFreePhoneUserId: customTextField!
    
    @IBOutlet var lblTitle: UILabel!
    
    //MARK: Initializer
    
    class func initViewController(contact:Receiver) -> ContactDetailVC {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ContactDetailVC") as! ContactDetailVC
        controller.contact = contact
        return controller
    }
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showData()
    }
    
    //MARK: Custom Method To Display Data
    
    func showData(){
        lblTitle.text = contact.receiver_name
        let name_arr = contact.receiver_name!.split(separator: " ")
        
        if name_arr.count == 1 {
            txtFirstName.text = String(name_arr[0])
            txtLastName.text = ""
        }
        if name_arr.count == 2 {
            txtFirstName.text = String(name_arr[0])
            txtLastName.text = String(name_arr[1])
        }
        
        txtCanteenAccountNumber.text = contact.receiver_id
        txtFreePhoneUserId.text = contact.free_user_id
    }
    
    //MARK: IB Actions
    
    @IBAction func btnBackPressed(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editClicked(_ sender: Any) {
        let controller = ContactEditVC.initViewController(contact: contact)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func deleteContactClicked(_ sender: Any) {
        let alert = UIAlertController.init(title: tDelete, message:tDeleteMessage, preferredStyle: .alert)
        let yesAction = UIAlertAction.init(title: tYes, style: .default) { (action) in
            self.deleteContactApi(contact: self.contact)
        }
        let noAction = UIAlertAction.init(title: tNo, style: .default) { (action) in
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Delete Contact API Call
    
    func deleteContactApi (contact:Receiver)  {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        contact.deleteContacts { (result, errorMessage) -> (Void) in
            self.stopAnimating()
            if(errorMessage.count > 0){
                Utils.showAlert(withMessage: errorMessage)
            }else{
                contact.is_deleted = true
                contact.saveEntity()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
