import UIKit
import NVActivityIndicatorView

class PaymentHistoryVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,NVActivityIndicatorViewable {
    
    @IBOutlet weak var tblView : UITableView!
    var paymentArray = [Payment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.tableFooterView = UIView()
        if(AccountManager.instance().activeAccount != nil){
            loadPaymentHistory()
        }else{
            Utils.showAlert(withMessage: "Unauthorized Request, Please sign in first.")
        }
    }
    
    func loadPaymentHistory()  {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        
        Manager.sharedManager().loadPaymenthistoryNewAPI { (response, errorMessage) -> (Void) in
            
            if(errorMessage.count > 0){
                self.stopAnimating()
                Utils.showAlert(withMessage: errorMessage)
                
            }else{
                self.perform(#selector(self.getDataFromDB), with: nil, afterDelay: 1.0)
            }
        }
        
//        Manager.sharedManager().loadPaymenthistory { (result, errorMessage) -> (Void) in
//            self.stopAnimating()
//            if(errorMessage.count > 0){
//                Utils.showAlert(withMessage: errorMessage)
//            }else{
//                self.paymentArray = Payment.getAll()
//                self.tblView.reloadData()
//            }
//        }
    }
    
    @objc func getDataFromDB() {
        self.stopAnimating()
        self.paymentArray = Payment.getAll()
        self.tblView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 169;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryCell") as! PaymentHistoryCell
        let payment: Payment = paymentArray[indexPath.row]
        cell.setData(payment: payment)
        cell.btnTypeStatus.addTarget(self, action: #selector(PaymentHistoryVC.btnStoreClicked(_:)), for: .touchUpInside)
        cell.btnTypeStatus.tag = indexPath.row;
        return cell
    }
    
    @objc func btnStoreClicked(_ sender : UIButton){
        let payment : Payment = paymentArray[sender.tag]
        if payment.payment_type == "0" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Payment2VC") as! Payment2VC
            
            Utils.setStringForKey(payment.payment_type!, key: kPaymentType)
            vc.payment = payment
            let totalA  : Float = (payment.total_amount?.floatValue)!
            let amount  : Float = (payment.amount?.floatValue)!
            let commision  = String((totalA - amount))
            vc.commissionAmount = commision
            vc.isFromPaymentHistory = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            Utils.showAlert(withMessage: "מצטערים השרות אינו זמין כעת נחזור בקרוב")
//            let vc = storyboard?.instantiateViewController(withIdentifier: "RecipientDetailVC") as! RecipientDetailVC
//            vc.strFirstName = (payment.rec_id?.receiver_name)!
//            vc.strUsrId = (payment.rec_id?.free_user_id)!
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
