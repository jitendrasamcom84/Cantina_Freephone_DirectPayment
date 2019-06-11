
import UIKit
import NVActivityIndicatorView
class AboutVC:BaseViewController , NVActivityIndicatorViewable,UIWebViewDelegate{
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.isHidden = true
        webView.loadRequest(URLRequest(url: URL(string: "http://cantina.admin.scteches.com/about.html")!))
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        webView.isHidden = true
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        self.perform(#selector(afterDelaySecond), with: nil, afterDelay: 1.0)
    }
    
    @objc func afterDelaySecond() {
        self.stopAnimating()
        webView.isHidden = false
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        self.perform(#selector(afterDelaySecond), with: nil, afterDelay: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
//        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.homeVC)
        if UIDevice.isIpadDevice{
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.HomeVC_iPad1x)
            
        }else{
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.homeVC)
        }
    }
}
