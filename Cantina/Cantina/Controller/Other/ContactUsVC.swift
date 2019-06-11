
import UIKit
import NVActivityIndicatorView
import UITextView_Placeholder
import ActionSheetPicker_3_0

class ContactUsVC: BaseViewController , NVActivityIndicatorViewable {
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtFullName: customTextField!
    @IBOutlet weak var txtPhone: customTextField!
    @IBOutlet weak var txtContentReferral: UITextView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    var selectValue = String()
    
    @IBOutlet weak var btnSelectSubject: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtFullName.text = ""
        txtPhone.text = ""
        txtContentReferral.text = ""
        btnSelectSubject.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right

        self.callAPi()
    }
    
    override func viewDidLayoutSubviews() {
        scroll.frame = CGRect(x: self.scroll.frame.origin.x,y:self.scroll.frame.origin.y  ,width:self.view.frame.size.width ,height: self.view.frame.size.height )
        scroll.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
    }
    
    //MARK: IB Actions
    
    @IBAction func btnBackClicked(_ sender: Any){
//        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.homeVC)
        if UIDevice.isIpadDevice{
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.HomeVC_iPad1x)
            
        }else{
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.homeVC)
        }
    }
    
    @IBAction func selectSubjectClicked(_ sender: Any) {
        ActionSheetStringPicker.show(withTitle: "", rows: ["קנטינה","פריפון"], initialSelection: 0, doneBlock: { (picker, selectedIndex, selectedValue) in
            self.selectValue = selectedValue as! String
            self.btnSelectSubject.setTitle(selectedValue as? String, for: .normal)
        }, cancel: { (picker) in
            
        }, origin: sender)
    }
    
    @IBAction func sendButtonClicked(_ sender: Any){
        var error_message = "";
        let strFullName = txtFullName.text!.trimmingCharacters(in: .whitespaces)
        let strPhone = txtPhone.text!.trimmingCharacters(in: .whitespaces)
        let strContentReferral = txtContentReferral.text!.trimmingCharacters(in: .whitespaces)
        if (strFullName.count <= 0){
            error_message = "נא להזין את שמך המלא!";
        } else if (strPhone.count <= 0){
            error_message = "הזן את הטלפון שלך!";
        }else if(strPhone.count < 6 || strPhone.count > 15){
            error_message = "הזן טלפון סלולרי חוקי";
        } else if (strContentReferral.count <= 0){
            error_message = "אנא הכנס את תוכן הפניה";
        }
        
        var type = String()
        if selectValue == "קנטינה"{
            type = "0"
        }
        else{
            type = "1"
        }
        
        if error_message.count > 0 {
            Utils.showAlert(withTitle: tMissingItems, withMessage: error_message, withButtonTitle:tApproval.localized)
            return;
        }
        startAnimating(loaderSize, message: tPleaseWait,  type: NVActivityIndicatorType.lineSpinFadeLoader)
        if AccountManager.instance().activeAccount == nil {
            let account = Account();
            
            account.contactUs(name: strFullName, phone: strPhone, message: strContentReferral, type: type) { (isSuccess, account, message) -> (Void) in
                self.stopAnimating()
                self.showAlert(message: message)
                self.txtFullName.text = ""
                self.txtPhone.text = ""
                self.txtContentReferral.text = ""
                return;
            }
        }else{
            let account = AccountManager.instance().activeAccount!
            account.contactUs(name: strFullName, phone: strPhone, message: strContentReferral, type: type) { (isSuccess, account, message) -> (Void) in
                self.stopAnimating()
                self.showAlert(message: message)
                self.txtFullName.text = ""
                self.txtPhone.text = ""
                self.txtContentReferral.text = ""
                return;
            }
        }
    }
    
    func showAlert(message : String){
        let alert = UIAlertController.init(title: tContactUs, message:message, preferredStyle: .alert)
        let okeyAction = UIAlertAction.init(title: tOkay, style: .default) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
            obj.strType = "Home"
            let navObj = UINavigationController.init(rootViewController: obj)
            navObj.navigationBar.isHidden = true
            AppDelegate.sharedInstance().window?.rootViewController = navObj
        }
        alert.addAction(okeyAction)
        self.present(alert, animated: true, completion: nil)
        return;
    }
    
    func callAPi() {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        let headers = [
            "content-type": "application/json"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: kBaseUrl + kAbout)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.stopAnimating()
            }
            if (error != nil) {
                self.stopAnimating()
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    print(json ?? "")
                    let serverData = json!
                    if let dataArr = serverData["data"] as? [[String : Any]] {
                        if dataArr.count > 0{
                            DispatchQueue.main.async {
                                self.stopAnimating()
                                let dict : [String : Any] = dataArr[0]
                                let email  = dict["email"];
                                let text  = dict["text"];
                                let address  = dict["address"];
                                let phone  = dict["phone"];
                                self.lblEmail.text = email as? String;
                                self.lblAddress.text = address as? String;
                                self.lblPhone.text = phone as? String;
                            }
                        }
                    }
                }catch let error as NSError{
                }
            }
        })
        dataTask.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
