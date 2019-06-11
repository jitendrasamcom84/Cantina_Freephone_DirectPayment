import UIKit
import NVActivityIndicatorView

class ContactEditVC: BaseViewController, NVActivityIndicatorViewable {
    
    var contact = Receiver()
    @IBOutlet weak var txtFirstName: customTextField!
    @IBOutlet weak var txtLastName: customTextField!
    @IBOutlet weak var txtCanteenAccountNumber: customTextField!
    @IBOutlet weak var txtUserNumber: customTextField!
    
    @IBOutlet var lblTitle: UILabel!
    
    //MARK: Initializer
    
    class func initViewController(contact:Receiver) -> ContactEditVC {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ContactEditVC") as! ContactEditVC
        controller.contact = contact
        return controller
    }
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ContactEditVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        showData()
    }
    
    //MARK: Custom Method to Display Data
    
    func showData () {
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
        txtUserNumber.text = contact.free_user_id
    }
    
    //MARK: Custom Method To Dismiss Keyboard
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: IB Actions
    
    @IBAction func btnBackPressed(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitPressed(_ sender: Any){
        let strFirstName = txtFirstName.text!.trimmingCharacters(in: .whitespaces)
        let strLastName = txtLastName.text!.trimmingCharacters(in: .whitespaces)
        let strnumber = txtCanteenAccountNumber.text!.trimmingCharacters(in: .whitespaces)
        if (strFirstName.count <= 0){
            Utils.showAlert(withTitle: tMissingItems, withMessage: "נא להזין שם פרטי!", withButtonTitle:tApproval.localized)
        } else if (strLastName.count <= 0){
            Utils.showAlert(withTitle: tMissingItems, withMessage: "נא להזין את שמך המלא!", withButtonTitle:tApproval.localized)
        }
//            else if (strnumber.count <= 0){
//            Utils.showAlert(withTitle: tMissingItems, withMessage: "הזן מספר חשבון!", withButtonTitle:tApproval.localized)
//        }
        else{
            contact.receiver_name = txtFirstName.text! + " " + txtLastName.text!
            contact.receiver_fname = txtFirstName.text
            contact.receiver_lname = txtLastName.text
            contact.receiver_id = txtCanteenAccountNumber.text!
            contact.free_user_id = txtUserNumber.text!
            editConatctApi()
        }
    }
    
    //MARK: - Edit API Call -
    
    func editConatctApi ()  {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        contact.editContacts { (result, errorMessage) -> (Void) in
            self.stopAnimating()
            if(errorMessage.count > 0){
                Utils.showAlert(withMessage: errorMessage)
            }else{
                self.contact.saveEntity()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLoadConatcts), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
