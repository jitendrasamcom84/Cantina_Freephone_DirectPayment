import UIKit

class BaseViewController: UIViewController , UIGestureRecognizerDelegate {
    
    var blurredEffectView = UIVisualEffectView()
    @IBOutlet weak var btnSideMenu : UIButton!
    var userId = String()
    var force_fully_update = Bool ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSideMeu()
        getAppStatusApiCall()
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
    
    func setSideMeu ()  {
        let blurEffect = UIBlurEffect(style: .extraLight)
        blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width + 40, height: self.view.frame.height + 20)
        blurredEffectView.backgroundColor = UIColor.white
        blurredEffectView.alpha = 0.70
       
        blurredEffectView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        blurredEffectView.addGestureRecognizer(tap)
        blurredEffectView.isUserInteractionEnabled = true
        self.view.addSubview(blurredEffectView)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        sideMenuViewController()?.menuContainerView?.toggleRightSideMenu();
        if sideMenuViewController()?.menuContainerView?.currentSideMenuState == .right{
            if self.isKind(of: ThankYouVC.self) || self.isKind(of: ComingSoonVC.self) || self.isKind(of: FreePhoneSuccessVC.self) || self.isKind(of: FreePhoneSuccessWithUserInfoVC.self) || self.isKind(of: DepositMoneyVC.self){
                btnSideMenu.setImage(UIImage(named:"Menu.png"), for: .normal)
            }
            else{
                btnSideMenu.setImage(UIImage(named:"MenuBlack.png"), for: .normal)
            }
            blurredEffectView.isHidden = true
        }
    }
    
    @objc func hideblurredEffectView() {
        blurredEffectView.isHidden = true
        if self.isKind(of: ThankYouVC.self) || self.isKind(of: ComingSoonVC.self) || self.isKind(of: FreePhoneSuccessVC.self) || self.isKind(of: FreePhoneSuccessWithUserInfoVC.self) || self.isKind(of: DepositMoneyVC.self){
            btnSideMenu.setImage(UIImage(named:"Menu.png"), for: .normal)
        }else{
            btnSideMenu.setImage(UIImage(named:"MenuBlack"), for: .normal)
        }
        view.bringSubview(toFront: btnSideMenu)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kHideBlurredEffectView), object: nil)
    }
    
    @IBAction func sideMenuclicked(_ sender: Any) {
        if (UserDefaults.standard.bool(forKey: isFreePhoneNewUser) == true) {
            if self.isKind(of: FreePhoneEnteringAmountVC.self) || self.isKind(of: FreePhonePaymentVC.self) || self.isKind(of: FreePhoneSuccessVC.self){
                let alert = UIAlertController.init(title: "", message:"במידה ותחזור למסך הקודם תהליך ההרשמה של משתמש פריפון חדש יפסק, להמשיך בכל זאת?", preferredStyle: .alert)
                let yesAction = UIAlertAction.init(title: "חזרה לאחור", style: .default) { (action) in
                    self.deleteUser(id: self.userId)
                }
                let noAction = UIAlertAction.init(title: "ביטול", style: .default) { (action) in
                }
                alert.addAction(yesAction)
                alert.addAction(noAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableView"), object: nil);
            NotificationCenter.default.addObserver(self, selector: #selector(self.hideblurredEffectView), name: NSNotification.Name(rawValue: kHideBlurredEffectView), object: nil)
            sideMenuViewController()?.menuContainerView?.toggleRightSideMenu();
            if sideMenuViewController()?.menuContainerView?.currentSideMenuState == .right {
                if self.isKind(of: ThankYouVC.self) || self.isKind(of: ThankYou2VC.self) || self.isKind(of: ComingSoonVC.self) || self.isKind(of: FreePhoneSuccessVC.self) || self.isKind(of: FreePhoneSuccessWithUserInfoVC.self) || self.isKind(of: DepositMoneyVC.self){
                    UIView.transition(with: sender as! UIView, duration: 0.75, options: .layoutSubviews, animations: {
                        (sender as AnyObject).setImage(UIImage(named:"Menu.png"), for: .normal)
                    }, completion: nil)
                }else{
                    UIView.transition(with: sender as! UIView, duration: 0.75, options: .layoutSubviews, animations: {
                        (sender as AnyObject).setImage(UIImage(named:"MenuBlack"), for: .normal)
                    }, completion: nil)
                }
                blurredEffectView.isHidden = true
            } else {
                if self.isKind(of: ThankYouVC.self) {
                    UIView.transition(with: sender as! UIView, duration: 0.75, options: .layoutSubviews, animations: {
                        (sender as AnyObject).setImage(UIImage(named:"MenuVertical"), for: .normal)
                    }, completion: nil)
                    blurredEffectView.isHidden = false
                    view.bringSubview(toFront: btnSideMenu)
                }
                else{
                    UIView.transition(with: sender as! UIView, duration: 0.75, options: .layoutSubviews, animations: {
                        (sender as AnyObject).setImage(UIImage(named:"Menu icon.png"), for: .normal)
                    }, completion: nil)
                    blurredEffectView.isHidden = false
                    view.bringSubview(toFront: btnSideMenu)
                }
            }
        }
    }
    
    func deleteUser(id: String) {
        let receiver = Receiver.getbyId(userId: id)
//        let user:UserList = UserList.getbyId(userId: userId)
        var isDeposit = Bool()
        
        if self.isKind(of: FreePhonePaymentVC.self) {
           isDeposit = true
        } else{
            isDeposit = false
        }
        receiver.delete(isDeposit: isDeposit) { (response, errorMessage) -> (Void) in
            if(errorMessage.count > 0){
                Utils.showAlert(withMessage: errorMessage)
            }else{
                receiver.delete()
                if self.isKind(of: FreePhonePaymentVC.self) {
                    UserDefaults.standard.set(false, forKey: isFreePhoneNewUser)
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true);
                }
                else
                if self.isKind(of: ThankYouVC.self){
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true);
                }
                else if self.isKind(of: FreePhoneSuccessVC.self) {
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true);
                }
                else{
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
                }
            }
        }
        
//        user.delete(isDeposit: isDeposit) { (respose, errorMessage) -> (Void) in
//            if(errorMessage.count > 0){
//                Utils.showAlert(withMessage: errorMessage)
//            }else{
//                user.delete()
//                if self.isKind(of: FreePhoneEnteringAmountVC.self) {
//                    self.navigationController?.popViewController(animated: true);
//                }
//                else if self.isKind(of: ThankYouVC.self){
//                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
//                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true);
//                }
//                else{
//                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
//                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
//                }
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
