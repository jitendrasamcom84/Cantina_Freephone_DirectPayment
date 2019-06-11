
import UIKit
import NVActivityIndicatorView
import FirebaseAuth
import IHKeyboardAvoiding


class LoginVC: UIViewController, NVActivityIndicatorViewable  {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgetPass: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtForgotPasswordPhone: UITextField!
    @IBOutlet weak var otpPopUpView: UIView!
    @IBOutlet weak var txtFPOTP: UITextField!
    @IBOutlet weak var txtFPPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        KeyboardAvoiding.avoidingView = self.popUpView
    }
    
    func setLayout(){
        self.btnLogin.layer.cornerRadius = 25
        self.btnLogin.layer.masksToBounds = true
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView.effect = blurEffect
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func forgetPassClicked(_ sender: Any){
        self.blurEffectView.isHidden = false
        self.popUpView.isHidden = false
        KeyboardAvoiding.avoidingView = self.popUpView
    }
    
    func validationPhoneNumber(){
        if txtForgotPasswordPhone.text != "" {
            verifyPhoneNumber()
        } else{
            self.view.makeToast(tFillContact)
        }
    }
    
    @IBAction func btnSubmitOTPPassClicked(_ sender: Any){
        validationOTPPAss()
    }
    
    func validationOTPPAss(){
        if txtFPOTP.text != "" {
            if txtFPPassword.text != "" {
                callapi()
            }else {
                self.view.makeToast(tFillPassword)
            }
        } else {
            self.view.makeToast(tFillContact)
        }
    }
    
    func verifyPhoneNumber() {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        let strPhone: String = "\(kCountryCode)\(txtForgotPasswordPhone.text ?? "")"
        let p = Utils.getPhoneNumberWithCode(phone: strPhone)
        PhoneAuthProvider.provider().verifyPhoneNumber(p, uiDelegate: nil) { (verificationID, error) in
            self.stopAnimating()
            if let error = error{
                print(error.localizedDescription)
                Utils.showAlert(withMessage: error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            Auth.auth().languageCode = "en";
            KeyboardAvoiding.avoidingView = self.otpPopUpView
            self.popUpView.isHidden = true
            self.otpPopUpView.isHidden = false
            self.txtFPOTP.text = ""
            self.txtFPPassword.text = ""
        }
    }
    
    func callapi() {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!, verificationCode: txtFPOTP.text!)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                Utils.showAlert(withMessage: error.localizedDescription)
                return
            } else{
                let acc : Account = Account()
                acc.phone = "\(kCountryCode)\(self.txtForgotPasswordPhone.text!)"
                self.startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
                acc.forgotPassword(password: self.txtFPPassword.text!)  { (result, account, errorMsg) -> (Void) in
                    self.stopAnimating()
                    if (errorMsg.count > 0) {
                        Utils.showAlert(withMessage: errorMsg)
                        return
                    }
                    self.otpPopUpView.isHidden = true
                    self.blurEffectView.isHidden = true
                }
            }
        }
    }
    
    @IBAction func btnLoginClicked(_ sender: Any){
        let strPhone = txtPhone.text!.trimmingCharacters(in: .whitespaces)
        let strPassword = txtPassword.text!.trimmingCharacters(in: .whitespaces)
        if  strPhone.count <= 0{
            Utils.showAlert(withTitle: tMissingItems, withMessage: tFillContact, withButtonTitle:tApproval.localized)
        }else if(strPhone.count < 6 || strPhone.count > 15){
            Utils.showAlert(withTitle: tMissingItems, withMessage: "הזן טלפון סלולרי חוקי", withButtonTitle:tApproval.localized)
        }else if strPassword.count <= 0{
            Utils.showAlert(withTitle: tMissingItems, withMessage: tFillPassword, withButtonTitle:tApproval.localized)
        } else if strPassword.count < 6{
            Utils.showAlert(withTitle: tMissingItems, withMessage: tPasswordLength, withButtonTitle:tApproval.localized)
        } else {
            startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
            let acc : Account = Account()
            acc.phone = "\(kCountryCode)\(strPhone)"
            acc.login(password: strPassword, block: { (isSuccess, account, errorMsg) -> (Void) in
                self.stopAnimating()
                if !isSuccess {
                    let alertController = UIAlertController(title: ALERT_TITLE, message: errorMsg , preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: tOkay, style: .default, handler: nil)
                    alertController.addAction(actionOk)
                    
                    self.present(alertController, animated: true)
                    
                } else {
                    AccountManager.instance().activeAccount = account;
                    self.navigationController?.isNavigationBarHidden = false;
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func btnRegisterClicked(_ sender: Any){
        let regObj = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC")
        let nav = navigationController
        nav?.pushViewController(regObj!, animated:true)
    }
    
    
    @IBAction func btnSkipClicked(_ sender: Any){
        self.navigationController?.isNavigationBarHidden = false;
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitPassClicked(_ sender: Any){
        validationPhoneNumber()
    }
    
    @IBAction func btnClosePopClicked(_ sender: Any){
        self.blurEffectView.isHidden = true
        self.popUpView.isHidden = true
        self.otpPopUpView.isHidden = true
    }
}
