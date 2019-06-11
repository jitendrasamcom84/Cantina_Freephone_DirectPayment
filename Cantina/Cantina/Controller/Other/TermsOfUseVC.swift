
import UIKit
import NVActivityIndicatorView

class TermsOfUseVC: BaseViewController , NVActivityIndicatorViewable , UIWebViewDelegate {
    
    @IBOutlet var webviewPage: UIWebView!
    var isFromDebitList : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webviewPage.delegate = self
        self.doAPICall()
    }
    
    func doAPICall(){
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        let headers = [
            "content-type": "application/json"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: kBaseUrl + kTerms)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                DispatchQueue.main.async {
                    self.stopAnimating()
                }
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    print(json ?? "")
                    let serverData = json!
                    if let dataArr = serverData["data"] as? [[String : Any]] {
                        if dataArr.count > 0{
                            DispatchQueue.main.async {
                                let dict : [String : Any] = dataArr[0]
                                let pdfName : String = dict["pdf"] as! String
                                let urlPart =  kBaseUrl + "api/image/get/" + pdfName
                                let url = URL.init(string:urlPart  )
                                let urlReq : URLRequest = URLRequest.init(url:url!)
                                self.webviewPage.loadRequest(urlReq)
                            }
                        }
                    }
                }catch let error as NSError{
                    DispatchQueue.main.async {
                        self.stopAnimating()
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.stopAnimating()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        if isFromDebitList {
            self.navigationController?.popViewController(animated: true)
        }else{
//            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.homeVC)
            if UIDevice.isIpadDevice{
                self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.HomeVC_iPad1x)
                
            }else{
                self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.homeVC)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
