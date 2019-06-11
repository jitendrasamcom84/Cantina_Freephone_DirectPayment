import UIKit

class SplashVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splashTimeOut()
    }
    
    func splashTimeOut(){
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        obj.strType = "Home"
        let navObj = UINavigationController.init(rootViewController: obj)
        navObj.navigationBar.isHidden = true
        AppDelegate.sharedInstance().window?.rootViewController = navObj
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
