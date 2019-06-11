
import UIKit

class Payment3VC: BaseViewController {
    
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet weak var webPayment: UIWebView!
    @IBOutlet var lblimgText: UILabel!
    @IBOutlet var payImg: UIImageView!
    var Amount = String()
    var btnHome = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Payment3VC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        let url = URL (string: "https://www.ynet.co.il/home/0,7340,L-8,00.html")
        let requestObj = URLRequest(url: url!)
        webPayment.loadRequest(requestObj)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblAmount.text = Amount
        if btnHome == "1" {
            payImg.image = UIImage(named:"store")!
            lblimgText.text =  "הפקדה לקנטינה"
        } else {
            payImg.image = UIImage(named:"payment-method")!
            lblimgText.text = "הפקדה לפרי-פון"
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupLayout(){
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UITextField {
    
    func setLeftIcon(_ icon: UIImage) {
        let padding = 0
        let size = 15
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
        iconView.image = icon
        outerView.addSubview(iconView)
        leftView = outerView
        leftViewMode = .always
    }
}
