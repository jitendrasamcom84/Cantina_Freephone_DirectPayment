
import UIKit
import NVActivityIndicatorView
import MagicalRecord
class QandAVC: BaseViewController, NVActivityIndicatorViewable  {
    
    @IBOutlet weak var tblView: UITableView!
    var cantinaArr = [QuestionAnswer]()
    var freePhoneArr = [QuestionAnswer]()
    
    var sections = ["קנטינה","פריפון"]
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var innerView: UIView!
    
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        tblView?.register(UINib(nibName: "QATableViewCell", bundle: nil), forCellReuseIdentifier: "QATableViewCell")
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 1000
        self.loadQuestionAnswer()
    }
    
    //MARK API Call to get Q&A
    
    func loadQuestionAnswer()  {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        let headers = [
            "content-type": "application/json"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: kBaseUrl + kQA)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 40.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.stopAnimating()
            }
            if (error != nil) {
                self.stopAnimating()
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    print(json ?? "")
                    let serverData = json!
                    DispatchQueue.main.async {
                        if let dataArray = serverData["data"] as? [[String : Any]] {
                            MagicalRecord.save(blockAndWait: { (localContext:NSManagedObjectContext) in
                                let arr = FEMDeserializer.collection(fromRepresentation: dataArray, mapping: QuestionAnswer.defaultMapping(), context: localContext)
                                DispatchQueue.main.async {
                                    self.setInformation()
                                    print(arr)
                                }
                            })
                        }
                    }
                }catch let error as NSError{
                    print(error)
                }
            }
        })
        dataTask.resume()
    }
    
    //MARK: Custom Method
    
    func setInformation() {
//        self.qa_Array = QuestionAnswer.getAll()
        
        cantinaArr = QuestionAnswer.getCantinaList()
        freePhoneArr = QuestionAnswer.getFreePhoneList()
        
//        self.qa_Array = cantinaArr.addingObjects(from: freePhoneArr as! [Any]) as! [QuestionAnswer]
        
        self.stopAnimating()
        self.tblView.reloadData()
        self.updateView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.updateView ()
        }
    }
    
    func updateView ()  {
        self.viewHeight.constant =  self.tblView.contentSize.height + 30
        innerView.layoutIfNeeded()
        innerView.needsUpdateConstraints()
        scrollView.layoutIfNeeded()
        scrollView.needsUpdateConstraints()
        self.view.layoutIfNeeded()
        self.view.needsUpdateConstraints()
    }
    
    //MARK: IB Actions
    
    @IBAction func btnBackClicked(_ sender: Any){
        if UIDevice.isIpadDevice{
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.HomeVC_iPad1x)
            
        }else{
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.homeVC)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QandAVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = String(sections[section])
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cantinaArr.count
        }
        else{
            return freePhoneArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "QATableViewCell") as! QATableViewCell
        
        if indexPath.section == 0{
            let qa : QuestionAnswer = cantinaArr[indexPath.row]
            cell.setData(questionAnswer: qa, index: indexPath.row)
        }
        else{
            let qa : QuestionAnswer = freePhoneArr[indexPath.row]
            cell.setData(questionAnswer: qa, index: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        headerView.backgroundColor = UIColor.clear
        
        let lblTopicName: UILabel = UILabel.init(frame: CGRect(x: self.view.frame.size.width-119, y: 5, width: 100, height: 27))

        lblTopicName.text = String(sections[section])
        lblTopicName.textColor = UIColor.darkGray
        lblTopicName.font = UIFont(name: "Rubik-Medium", size: 22)
        lblTopicName.textAlignment = .right
        headerView.addSubview(lblTopicName)
        return headerView
    }
}
