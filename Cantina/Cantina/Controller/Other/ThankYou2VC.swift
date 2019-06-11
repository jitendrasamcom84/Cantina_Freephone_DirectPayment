import UIKit

class ThankYou2VC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func redClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bottomClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
