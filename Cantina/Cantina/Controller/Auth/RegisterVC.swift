
import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class RegisterVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet var lineOtp: UIImageView!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtPhone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.navigationController?.isNavigationBarHidden = true;
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setLayout(){
        self.btnRegister.layer.cornerRadius = 25
        self.btnRegister.layer.masksToBounds = true
    }
    
    @IBAction func btnRegClicked(_ sender: Any){
        validation()
    }
    
    @IBAction func backClicked(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func skipClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func validation(){
        let strPhone = txtPhone.text!.trimmingCharacters(in: .whitespaces)
        let strPassword = txtPassword.text!.trimmingCharacters(in: .whitespaces)
        let strName = txtName.text!.trimmingCharacters(in: .whitespaces)
        if  strName.count <= 0{
            Utils.showAlert(withTitle: tMissingItems, withMessage: tUsername, withButtonTitle:tApproval.localized)
        }else if strPhone.count <= 0{
            Utils.showAlert(withTitle: tMissingItems, withMessage: tFillPassword, withButtonTitle:tApproval.localized)
        }else if(strPhone.count < 6 || strPhone.count > 15){
            Utils.showAlert(withTitle: tMissingItems, withMessage: "הזן טלפון סלולרי חוקי", withButtonTitle:tApproval.localized)
        }else if strPassword.count <= 0{
            Utils.showAlert(withTitle: tMissingItems, withMessage: tFillPassword, withButtonTitle:tApproval.localized)
        } else if strPassword.count < 6{
            Utils.showAlert(withTitle: tMissingItems, withMessage: tPasswordLength, withButtonTitle:tApproval.localized)
        }else{
            callapi()
        }
    }
    
    func callapi() {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        let strPhone: String = (txtPhone.text ?? "")
        let p = Utils.getPhoneNumberWithCode(phone: strPhone)
        PhoneAuthProvider.provider().verifyPhoneNumber(p, uiDelegate: nil) { (verificationID, error) in
            self.stopAnimating()
            if let error = error {
                print(error.localizedDescription)
                Utils.showAlert(withMessage: error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            Auth.auth().languageCode = "en";
            let regObj: Register2VC = self.storyboard?.instantiateViewController(withIdentifier: "Register2VC") as! Register2VC
            regObj.strName = self.txtName.text
            regObj.strPhone = self.txtPhone.text
            regObj.strPassword = self.txtPassword.text
            let nav = self.navigationController
            nav?.pushViewController(regObj, animated:true)
        }
    }
}
