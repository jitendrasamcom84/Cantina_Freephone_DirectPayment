
import UIKit
import NVActivityIndicatorView
class DebitPaymentViewController: BaseViewController , UIWebViewDelegate , NVActivityIndicatorViewable{
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet weak var lblTitle: UILabel!
    var debitId : String = String()
    var webUrl : String = String()
    var amount : String = String()
    var total_amount : String = String()
    @IBOutlet var payImg: UIImageView!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblimgText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblAmount.text =  Utils.getFractionPart(amount: amount)
        if Utils.fetchString(forKey: kPaymentType) == "0" {
            payImg.image = UIImage(named:"store")!
            lblimgText.text =  "הפקדה לקנטינה"
        } else {
            payImg.image = UIImage(named:"payment-method")!
            lblimgText.text = "הפקדה לפרי-פון"
        }
        self.webView.isHidden = false
        self.lblTitle.text = "תשלום";
       
        if let encoded = (webUrl as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            
            let url = URL(string: encoded) {
            let urlReq : URLRequest = URLRequest.init(url:url)
            self.webView.loadRequest(urlReq)
        }
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadDebitHistory()  {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        Manager.sharedManager().loadDebitList { (result, errorMessage) -> (Void) in
            self.stopAnimating()
            if(errorMessage.count > 0){
                Utils.showAlert(withMessage: errorMessage)
            }else{
                if let text = self.webView.request?.url?.absoluteString{
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let strSuccess = "\(kBaseUrl)\(kPaymentUrl)paymentsuccessnew" //"http://109.237.25.22:3051/api/payments/paymentsuccess"
                    let strFail = "\(kBaseUrl)\(kPaymentUrl)paymentfailnew" //"http://109.237.25.22:3051/api/payments/paymentfail"
                    if(text.contains("paymentsuccessnew")){
                        let controller = storyBoard.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
                        controller.isFromDebit = true
                        controller.diposite_number = self.debitId
                        self.navigationController?.pushViewController(controller, animated: true)
                    } else if(text.contains("paymentfailnew")){
                        let controller = storyBoard.instantiateViewController(withIdentifier: "ThankYou2VC") as! ThankYou2VC
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
//                    if(text == strSuccess){
//
//                        let controller = storyBoard.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
//                        controller.isFromDebit = true
//                        controller.diposite_number = self.debitId
//                        self.navigationController?.pushViewController(controller, animated: true)
//
////                        let message  = "האם ברצונך לשמור מספר כרטיס אשראי?"
////                        let alert = UIAlertController.init(title: "", message:message, preferredStyle: .alert)
////                        let approveAction = UIAlertAction.init(title: "כן", style: .default) { (action) in
////                            self.updateSaveCardStatusApi()
////
////                        }
////                        let decilneAction = UIAlertAction.init(title: "לא", style: .default) { (action) in
////                            let controller = storyBoard.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
////                            controller.isFromDebit = true
////                            controller.diposite_number = self.debitId
////                            self.navigationController?.pushViewController(controller, animated: true)
////                        }
////                        alert.addAction(decilneAction)
////                        alert.addAction(approveAction)
////                        self.present(alert, animated: true, completion: nil)
////                        return;
//
//
//                    } else if(text == strFail){
//                        let controller = storyBoard.instantiateViewController(withIdentifier: "ThankYou2VC") as! ThankYou2VC
//                        self.navigationController?.pushViewController(controller, animated: true)
//                    }
                }
            }
        }
    }
    func updateSaveCardStatusApi() {
        self.startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        Manager.sharedManager().saveCard(paymentId: self.debitId, pay_type: "2") { (result, message) -> (Void) in
            self.stopAnimating()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
            controller.isFromDebit = true
            controller.diposite_number = self.debitId
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadDebitHistory()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        Utils.showAlert(withMessage: error.localizedDescription)
        self.stopAnimating()
    }
}

