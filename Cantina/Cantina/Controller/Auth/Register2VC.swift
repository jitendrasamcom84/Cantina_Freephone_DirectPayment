
import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class Register2VC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet var txtCode: UITextField!
    var strPhone:String!
    var strName:String!
    var strPassword:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    @IBAction func btnLoginRegClicked(_ sender: Any){
        validation()
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func alreadyAccountClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func validation(){
        if txtCode.text != "" {
            callapi()
        } else{
            self.view.makeToast("הכנס קוד אימות")
        }
    }
    
    func callapi() {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!, verificationCode: txtCode.text!)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                Utils.showAlert(withMessage: error.localizedDescription)
                return
            } else {
                //MARK: User is signed in
                print(user?.phoneNumber ?? String())
                print(user?.providerID ?? String())
                let acc : Account = Account()
                acc.username = self.strName
                acc.phone = (self.strPhone ?? "")
                self.startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
                acc.registerUser(password: self.strPassword, block: { (result, account, errorMsg) -> (Void) in
                    self.stopAnimating()
                    if (errorMsg.count > 0) {
                        Utils.showAlert(withMessage: errorMsg)
                        return
                    }
                    AccountManager.instance().activeAccount = account;
                    
                    self.navigationController?.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
