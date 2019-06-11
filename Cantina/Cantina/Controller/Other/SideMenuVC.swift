
import UIKit
import FirebaseAuth
class SideMenuVC: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name:NSNotification.Name(rawValue: "reloadTableView"), object: nil);
        tblview?.register(UINib(nibName: "UserNameTableViewCell", bundle: nil), forCellReuseIdentifier: "UserNameTableViewCell")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func reloadTableView(){
        self.tblview.reloadData();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserNameTableViewCell") as! UserNameTableViewCell
            cell.lblUsername.text = "אורח"
            if AccountManager.instance().activeAccount != nil {
                let account = AccountManager.instance().activeAccount!;
                if account.username.count > 0{
                    cell.lblUsername.text = account.username;
                    
                }
            }
            cell.lblUsername.font = UIFont(name: "Rubik-Medium", size: 24)
            cell.selectionStyle = .none
            return cell
            
        case 1:
            cell.lblMenu.text = "עמוד הבית"
            cell.imgMenu.image = UIImage.init(named: "store red.png")
            cell.lblMenu.font.withSize(18)
        case 2:
            cell.lblMenu.text = "אודות"
            cell.imgMenu.image = UIImage.init(named: "megaphone.png")
            cell.lblMenu.font.withSize(18)
        case 3:
            cell.lblMenu.text = "תנאי השימוש"
            cell.imgMenu.image = UIImage.init(named: "letter.png")
            cell.lblMenu.font.withSize(18)
        case 4:
            cell.lblMenu.text = "שאלות ותשובות"
            cell.imgMenu.image = UIImage.init(named: "Q&A.png")
            cell.lblMenu.font.withSize(18)
        case 5:
            cell.lblMenu.text = "צור קשר"
            cell.imgMenu.image = UIImage.init(named: "phone-call.png")
            cell.lblMenu.font.withSize(18)
        case 6:
            if AccountManager.instance().activeAccount != nil {
                cell.lblMenu.text = "יציאה"
            }else{
                cell.lblMenu.text = "כניסה"
            }
            cell.imgMenu.image = UIImage.init(named: "logout.png")
            cell.lblMenu.font.withSize(18)
        default:
            cell.lblMenu.text = ""
            cell.imgMenu.image = UIImage.init(named: "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if(indexPath.row == 0){
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kHideBlurredEffectView), object: nil)
        switch indexPath.row {
        case 1:
            self.navigationController?.popToRootViewController(animated: true)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
            obj.strType = "Home"
            let navObj = UINavigationController.init(rootViewController: obj)
            navObj.navigationBar.isHidden = true
            AppDelegate.sharedInstance().window?.rootViewController = navObj
        case 2:
            NotificationCenter.default.post(name: KVSideMenu.Notifications.toggleRight, object: nil)
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.aboutVC)
        case 3:
            NotificationCenter.default.post(name: KVSideMenu.Notifications.toggleRight, object: nil)
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.termsOfUseVC)
        case 4:
            NotificationCenter.default.post(name: KVSideMenu.Notifications.toggleRight, object: nil)
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.qandAVC)
        case 5:
            NotificationCenter.default.post(name: KVSideMenu.Notifications.toggleRight, object: nil)
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.contactUsVC)
        case 6:
            if AccountManager.instance().activeAccount != nil {
                let account = AccountManager.instance().activeAccount!;
                if account.username.count > 0{
                    self.navigationController?.popToRootViewController(animated: false)
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
                    obj.strType = "Home"
                    let navObj = UINavigationController.init(rootViewController: obj)
                    navObj.navigationBar.isHidden = true
                    AppDelegate.sharedInstance().window?.rootViewController = navObj
                    let alert = UIAlertController.init(title: title, message:"בטוח/ה שרוצה להתנתק?", preferredStyle: .alert)
                    let yesAction = UIAlertAction.init(title: "כן", style: .default) { (action) in
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            AccountManager.instance().activeAccount = nil
                            appDelegateShared?.clearDatabase()
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kOpenLoginPage), object: nil)
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                    }
                    let noAction = UIAlertAction.init(title: "לא", style: .default) { (action) in
                    }
                    alert.addAction(yesAction)
                    alert.addAction(noAction)
                    navObj.present(alert, animated: true, completion: nil)
                }
            }else{
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    AccountManager.instance().activeAccount = nil
                    appDelegateShared?.clearDatabase()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kOpenLoginPage), object: nil)
                    self.navigationController?.popToRootViewController(animated: false)
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
                    obj.strType = "Home"
                    let navObj = UINavigationController.init(rootViewController: obj)
                    navObj.navigationBar.isHidden = true
                    AppDelegate.sharedInstance().window?.rootViewController = navObj
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            }
        default:
            break
        }
    }
}
