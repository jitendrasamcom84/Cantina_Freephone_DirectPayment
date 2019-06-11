
import UIKit
import Firebase
import NVActivityIndicatorView

@objc protocol HomeVCDelegate {
    func myTextFieldDidChange(str: String)
}

class HomeVC: UIViewController ,UIGestureRecognizerDelegate, NVActivityIndicatorViewable{
    
    var delegate :  HomeVCDelegate? = nil
    
    @IBOutlet weak var btnSideMenu: UIButton!

    var passedBtn = String()
    var blurredEffectView = UIVisualEffectView()
    
    @IBOutlet var img1: UIImageView!
    @IBOutlet var img2: UIImageView!
    @IBOutlet var img3: UIImageView!
    @IBOutlet var img4: UIImageView!
    @IBOutlet var img5: UIImageView!
    
    @IBOutlet var lblFirst: UILabel!
    @IBOutlet var lblSecond: UILabel!
    @IBOutlet var lblThird: UILabel!
    
    var force_fully_update = Bool ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let blurEffect = UIBlurEffect(style: .extraLight)
        blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        blurredEffectView.backgroundColor = UIColor.white
        blurredEffectView.alpha = 0.70
        view.addSubview(blurredEffectView)
        blurredEffectView.isHidden = true
        sideMenuViewController()?.menuContainerView?.allowPanGesture = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        blurredEffectView.addGestureRecognizer(tap)
        blurredEffectView.isUserInteractionEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(openLoginPage), name: NSNotification.Name(rawValue: kOpenLoginPage), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkUserExistApiCall(notification:)), name: NSNotification.Name(rawValue: kCheckUserExistsWithObject), object: nil)
        
        getAppStatusApiCall()
        getCalculateCommission()
        getFreePhoneCalculateCommission()
    }
    
    //MARK: - API Call for temporarily Stop Activity Option -
    func getAppStatusApiCall() {
        Manager.sharedManager().getAppStatus { (result, errorMessage) -> (Void) in
            if(errorMessage.count > 0){
                Utils.showAlert(withMessage: errorMessage)
            }else{
                let dict : [String : Any] = result as! [String:Any]
                self.force_fully_update = dict["force_fully_update"] as! Bool
                let under_maintanance : Bool = dict["under_maintanance"] as! Bool
                if self.force_fully_update == true{
                    DispatchQueue.global().async {
                        if self.isUpdateAvailable() {
                            let alert = UIAlertController.init(title: "", message:"נא להוריד את הגרסה העדכנית מחנות האפליקציות", preferredStyle: .alert)
                            let yesAction = UIAlertAction.init(title: tOkay, style: .default) { (action) in
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                            alert.addAction(yesAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            self.force_fully_update = false
                        }
                    }
                }
                else if under_maintanance == true{
                    let under_maintanance_message : String = dict["under_maintanance_message"] as! String
                    Utils.showAlert(withMessage: under_maintanance_message)
                }
            }
        }
    }
    
    
    func isUpdateAvailable() -> Bool {
        let info = Bundle.main.infoDictionary
        let currentVersion = info?["CFBundleShortVersionString"] as? String
        let identifier = info?["CFBundleIdentifier"] as? String
        let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier ?? "")")
        do {
            let data = try Data(contentsOf: url!)
            let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
            if let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
                print("version in app store", version,currentVersion ?? "");
            return version != currentVersion
            }
        }
        catch{
        }
        return true
    }
    
    @objc func openLoginPage(){
        let loginController = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let nav = UINavigationController.init(rootViewController: loginController)
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
    @objc func hideblurredEffectView() {
        blurredEffectView.isHidden = true
        btnSideMenu.setImage(UIImage(named:"Menu.png"), for: .normal)
        view.bringSubview(toFront: btnSideMenu)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kHideBlurredEffectView), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)    {
        self.fadeInAnimation()
        blurredEffectView.isHidden = true
        btnSideMenu.setImage(UIImage(named:"Menu.png"), for: .normal)
        view.bringSubview(toFront: btnSideMenu)
    }
    
    //MARK: - IB's Actions -
    
    @IBAction func btnSideMenuClicked(_ sender: UIButton){
        Utils.setBoolForKey(false, key: isFreePhoneNewUser)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableView"), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.hideblurredEffectView), name: NSNotification.Name(rawValue: kHideBlurredEffectView), object: nil)
        sideMenuViewController()?.menuContainerView?.toggleRightSideMenu();
        if sideMenuViewController()?.menuContainerView?.currentSideMenuState == .right {
            UIView.transition(with: sender as UIView, duration: 0.75, options: .layoutSubviews, animations: {
                sender.setImage(UIImage(named:"Menu.png"), for: .normal)
            }, completion: nil)
            blurredEffectView.isHidden = true
        } else {
            UIView.transition(with: sender as UIView, duration: 0.75, options: .layoutSubviews, animations: {
                sender.setImage(UIImage(named:"Menu icon.png"), for: .normal)
            }, completion: nil)
            view.bringSubview(toFront: btnSideMenu)
            blurredEffectView.isHidden = false
        }
    }
    
    @IBAction func cantinaDepositClicked(_ sender: Any) {
        if self.force_fully_update == true{
            let alert = UIAlertController.init(title: "", message:"נא להוריד את הגרסה העדכנית מחנות האפליקציות", preferredStyle: .alert)
            let yesAction = UIAlertAction.init(title: tOkay, style: .default) { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let account = AccountManager.instance().activeAccount
            if account != nil{
                let vc = storyboard?.instantiateViewController(withIdentifier: "Payment1VC") as! Payment1VC
                vc.isFromHome = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                openLoginPage()
            }
        }
    }
    
    @IBAction func freePhoneDepositClicked(_ sender: Any) {
        if self.force_fully_update == true{
            let alert = UIAlertController.init(title: "", message:"נא להוריד את הגרסה העדכנית מחנות האפליקציות", preferredStyle: .alert)
            let yesAction = UIAlertAction.init(title: tOkay, style: .default) { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let account = AccountManager.instance().activeAccount
            if account != nil{
                Utils.showAlert(withMessage: "מצטערים השרות אינו זמין כעת נחזור בקרוב")
                //            let vc = storyboard?.instantiateViewController(withIdentifier: "RecipientDetailVC") as! RecipientDetailVC
                //            vc.strFirstName = ""
                //            vc.strUsrId = ""
                //            self.navigationController?.pushViewController(vc, animated: true)
            }else{
                openLoginPage()
            }
        }
    }
    
    @IBAction func p_historyClicked(_ sender: Any) {
        if self.force_fully_update == true{
            let alert = UIAlertController.init(title: "", message:"נא להוריד את הגרסה העדכנית מחנות האפליקציות", preferredStyle: .alert)
            let yesAction = UIAlertAction.init(title: tOkay, style: .default) { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            if(AccountManager.instance().activeAccount == nil){
                let loginController = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let nav = UINavigationController.init(rootViewController: loginController)
                self.navigationController?.present(nav, animated: true, completion: nil)
            }else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "PaymentHistoryVC") as! PaymentHistoryVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func debitListClicked(_ sender: Any) {
        if self.force_fully_update == true{
            let alert = UIAlertController.init(title: "", message:"נא להוריד את הגרסה העדכנית מחנות האפליקציות", preferredStyle: .alert)
            let yesAction = UIAlertAction.init(title: tOkay, style: .default) { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            if(AccountManager.instance().activeAccount == nil){
                let loginController = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let nav = UINavigationController.init(rootViewController: loginController)
                self.navigationController?.present(nav, animated: true, completion: nil)
            }else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "DebitListVC") as! DebitListVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func myContactClicked(_ sender: Any) {
        if self.force_fully_update == true{
            let alert = UIAlertController.init(title: "", message:"נא להוריד את הגרסה העדכנית מחנות האפליקציות", preferredStyle: .alert)
            let yesAction = UIAlertAction.init(title: tOkay, style: .default) { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            if(AccountManager.instance().activeAccount == nil){
                let loginController = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let nav = UINavigationController.init(rootViewController: loginController)
                self.navigationController?.present(nav, animated: true, completion: nil)
            }else{
                //            let recepientVC = storyboard?.instantiateViewController(withIdentifier: "RecipientDetailVC") as! RecipientDetailVC
                let controller = MyContactsVC.initViewController(isFromHome: true)
                //            self.navigationController?.pushViewController(recepientVC, animated: false)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    
//    @IBAction func contactSelectClicked(_ sender: Any) {
//        if(AccountManager.instance().activeAccount == nil){
//            let loginController = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//            let nav = UINavigationController.init(rootViewController: loginController)
//            self.navigationController?.present(nav, animated: true, completion: nil)
//        }else{
//            let controller = MyContactsVC.initViewController(isFromHome: true)
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//    }
    
    //MARK: - Calculate Commission API Call -
    
    func getCalculateCommission() {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        Manager.sharedManager().loadCalculationCommission { (result, error) -> (Void) in
            self.stopAnimating()
            //self.myTextFieldDidChange(self.txtAmount)
        }
    }
    
    //MARK: - FreePhone Calculate Commission API Call -
    
    func getFreePhoneCalculateCommission() {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        Manager.sharedManager().loadFreePhoneCalculationCommission { (result, error) -> (Void) in
            self.stopAnimating()
        }
    }
    
    //MARK: - Custom Animation Method -
    
    func fadeInAnimation(){
        img1.alpha = 0.0
        img2.alpha = 0.0
        img3.alpha = 0.0
        img4.alpha = 0.0
        img5.alpha = 0.0
        lblFirst.alpha = 0.0
        lblSecond.alpha = 0.0
        lblThird.alpha = 0.0
        // fade in
        UIView.animate(withDuration: 0.5, animations: {
            self.img1.alpha = 1.0
            self.lblFirst.alpha = 1.0
        }) { (finished) in
        }
        UIView.animate(withDuration: 1.0, animations: {
            self.img2.alpha = 1.0
        }) { (finished) in
        }
        UIView.animate(withDuration: 1.5, animations: {
            self.img3.alpha = 1.0
            self.lblSecond.alpha = 1.0
        }) { (finished) in
        }
        UIView.animate(withDuration: 2.0, animations: {
            self.img4.alpha = 1.0
        }) { (finished) in
        }
        UIView.animate(withDuration: 2.5, animations: {
            self.img5.alpha = 1.0
            self.lblThird.alpha = 1.0
        }) { (finished) in
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        sideMenuViewController()?.menuContainerView?.toggleRightSideMenu();
        if sideMenuViewController()?.menuContainerView?.currentSideMenuState == .right {
            btnSideMenu.setImage(UIImage(named:"Menu.png"), for: .normal)
            blurredEffectView.isHidden = true
        }
    }
    
    @objc func checkUserExistApiCall(notification:NSNotification){
        if let receiver = notification.userInfo?["data"] as? Receiver {
            Manager.sharedManager().checkUserExists(userList: receiver) { (result, errorMessage) -> (Void) in
                self.stopAnimating()
                if(errorMessage.count > 0){
                    Utils.showAlert(withMessage: errorMessage)
                }else{
                    let id : String = result as! String
                    let user : Receiver = Receiver.getbyId(userId: id)
                    
                    receiver.balance = user.balance
                    receiver.dateAdded = user.dateAdded
                    receiver.entity_id = user.entity_id
                    receiver.receiver_fname = user.receiver_fname
                    receiver.receiver_lname = user.receiver_lname
                    receiver.receiver_name = user.receiver_name
                    receiver.is_deleted = user.is_deleted
                    receiver.user_id = user.user_id
                    receiver.main_free_user_id = user.main_free_user_id
                    receiver.free_user_id = user.free_user_id
                    receiver.free_user_pass = user.free_user_pass
                    
                    let vc = DepositMoneyVC.initViewController(user: receiver, isFromNotification: true)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
