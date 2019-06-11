
import UIKit
import NVActivityIndicatorView
class DebitListVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,NVActivityIndicatorViewable {
    
    @IBOutlet weak var tblView : UITableView!
    var debitListArray = [DebitList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadPaymentHistory), name: NSNotification.Name(rawValue: kLoadDebitListNotification), object: nil)
        if(AccountManager.instance().activeAccount != nil){
            debitListArray = DebitList.getAll()
            tblView.reloadData()
            loadPaymentHistory()
        }else{
            Utils.showAlert(withMessage: "Unauthorized Request, Please sign in first.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(AccountManager.instance().activeAccount != nil){
            debitListArray = DebitList.getAll()
            tblView.reloadData()
        }else{
            Utils.showAlert(withMessage: "Unauthorized Request, Please sign in first.")
        }
    }
    
    @objc func loadPaymentHistory()  {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        Manager.sharedManager().loadDebitList { (result, errorMessage) -> (Void) in
            self.stopAnimating()
            if(errorMessage.count > 0){
                Utils.showAlert(withMessage: errorMessage)
            }else{
                self.debitListArray = DebitList.getAll()
                self.tblView.reloadData()
            }
        }
    }
    
    @IBAction func addDebitClicked(_ sender: Any) {
        let debit = DebitList.createEntity()
        let controller = DebitEditVC.initViewController(debit: debit, isEdited: false)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return debitListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "DebitListCell") as! DebitListCell
        let debit: DebitList = debitListArray[indexPath.row]
        cell.setData(debit: debit)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblView.deselectRow(at: indexPath, animated: true)
        let debit: DebitList = debitListArray[indexPath.row]
        if(debitListArray.count > 0){
            let controller = DebitDetailVC.initViewController(debit: debit)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
