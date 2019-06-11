
import UIKit
import NVActivityIndicatorView

class DebitDetailVC: BaseViewController , NVActivityIndicatorViewable {
    
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var txtDate: customTextField!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var txtFirstName: customTextField!
    @IBOutlet weak var txtLastName: customTextField!
    @IBOutlet weak var txtPaymentPrice: customTextField!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var lblTitle: UILabel!
    var debit = DebitList()
    var paymentId = String()
    
    class func initViewController(debit:DebitList) -> DebitDetailVC {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DebitDetailVC") as! DebitDetailVC
        controller.debit = debit
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func methodCall(){
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showData()
    }
    
    override func viewDidLayoutSubviews() {
        self.scroll.frame = CGRect(x:self.scroll.frame.origin.x ,y:self.scroll.frame.origin.y ,width:self.scroll.frame.size.width ,height:self.view.frame.size.height )
        self.scroll.contentSize = CGSize(width: self.scroll.frame.size.width, height: self.btnDelete.frame.origin.y + self.btnDelete.frame.size.height + self.imgHeader.frame.size.height + 5 )
    }
    
    func showData()  {
        if(debit.payment_type == 0){
        }else{
        }
        txtFirstName.text = debit.receiver_name
        txtLastName.text  = debit.receiver_id
        txtPaymentPrice.text = "₪\(String(describing: debit.amount!))"
        txtDate.text = String(describing: debit.date!)
        lblTitle.text = debit.receiver_name
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editClicked(_ sender: Any) {
        let controller = DebitEditVC.initViewController(debit: debit, isEdited: true)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        let alert = UIAlertController.init(title: tDelete, message:tDeleteMessage, preferredStyle: .alert)
        let yesAction = UIAlertAction.init(title: tYes, style: .default) { (action) in
            self.deleteDebit(debit: self.debit)
        }
        let noAction = UIAlertAction.init(title: tNo, style: .default) { (action) in
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteDebit (debit:DebitList)  {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        debit.deleteDebitById { (respose, errorMessage) -> (Void) in
            self.stopAnimating()
            if(errorMessage.count > 0){
                Utils.showAlert(withMessage: errorMessage)
            }else{
                self.debit.is_deleted = true;
                self.debit.saveEntity();
                self.navigationController?.popViewController(animated: true);
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
