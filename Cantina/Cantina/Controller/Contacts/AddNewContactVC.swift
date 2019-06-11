
import UIKit
import NVActivityIndicatorView
import MagicalRecord

class AddNewContactVC: BaseViewController, NVActivityIndicatorViewable {
    
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet weak var txtCanteenAccountNumber: customTextField!
    @IBOutlet weak var txtFreePhoneUserId: customTextField!
    
    //MARK: Initializer
    
    class func initViewController() -> AddNewContactVC {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "AddNewContactVC") as! AddNewContactVC
        return controller
    }
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddNewContactVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: Custom Method
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: IB Action
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        let strFirstName = txtFirstName.text!.trimmingCharacters(in: .whitespaces)
        let strLastName = txtLastName.text!.trimmingCharacters(in: .whitespaces)
     //   let strnumber = txtCanteenAccountNumber.text!.trimmingCharacters(in: .whitespaces)
        if (strFirstName.count <= 0){
            Utils.showAlert(withTitle: tMissingItems, withMessage: "נא להזין שם פרטי!", withButtonTitle:tApproval.localized)
        } else if (strLastName.count <= 0){
            Utils.showAlert(withTitle: tMissingItems, withMessage: "נא להזין את שמך המלא!", withButtonTitle:tApproval.localized)
        }
//            else if (strnumber.count <= 0){
//            Utils.showAlert(withTitle: tMissingItems, withMessage: "הזן מספר חשבון!", withButtonTitle:tApproval.localized)
//        }
            else{
            addContactApi()
        }
    }
    
    //MARK: Add Contact API Call
    
    func addContactApi ()  {
        let contact: Receiver = Receiver.createEntity()
        contact.receiver_name = txtFirstName.text! + " " + txtLastName.text!
        contact.receiver_id = txtCanteenAccountNumber.text!
        contact.free_user_id = txtFreePhoneUserId.text!
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        contact.addContacts { (result, errorMessage) -> (Void) in
            self.stopAnimating()
            contact.mr_deleteEntity()
            contact.saveEntity()
            if(errorMessage.count > 0){
                Utils.showAlert(withMessage: errorMessage)
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLoadConatcts), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
