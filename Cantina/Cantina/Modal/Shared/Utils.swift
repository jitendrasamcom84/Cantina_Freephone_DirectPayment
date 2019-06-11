

import UIKit
import Foundation

let ALERT_TITLE: String = ""

class Utils: NSObject {
    
    class func getTopViewController() -> UIViewController {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController!
    }
    
    class func getFractionPart(amount : String) -> String {
        let arr = amount.components(separatedBy: ".")
        if arr.count == 1 {
             return arr[0] as String
        }
        if arr.count == 2 {
            let inAmount : Int = Int(arr[1])!
            
            if inAmount > Int(0){
                return amount
            }
            return arr[0] as String
        }
        return "0"
    }
    
    class func getPhoneNumberWithCode(phone : String) -> String{
        let string = phone
        if string.range(of:"+") != nil {
            // +91 contry code exsting code
            return string
        }
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
            let number  =  CountryInfo.parseJSON(code: countryCode) + phone
            return number;
        }
        return phone
    }
    
    class func showAlert(withMessage message: String) {
        let alertController = UIAlertController(title: ALERT_TITLE, message: message , preferredStyle: .alert)
        let actionOk = UIAlertAction(title: tOkay, style: .default, handler: nil)
        alertController.addAction(actionOk)
        Utils.getTopViewController().present(alertController, animated: true)
    }
    
    class func showAlert(withTitle:String, withMessage: String, withButtonTitle:String) {
        let alertController = UIAlertController(title: withTitle, message: withMessage , preferredStyle: .alert)
        let actionOk = UIAlertAction(title: withButtonTitle, style: .default, handler: nil)
        alertController.addAction(actionOk)
        Utils.getTopViewController().present(alertController, animated: true)
    }
    
    class func isEmail(txt: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", options: .caseInsensitive)
        return regex?.firstMatch(in: txt, options: [], range: NSMakeRange(0, txt.count)) != nil
    }
    
    class func isNumber(number:String) -> Bool{
        var numberRegEx = "[0-9]{10,13}"
        var numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        if numberTest.evaluate(with: number) == true {
            return true
        }
        else {
            return false
        }
    }
    
    class func isZipcode(number:String) -> Bool{
        var numberRegEx = "[0-9]{1,10}"
        var numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        if numberTest.evaluate(with: number) == true {
            return true
        }
        else {
            return false
        }
    }
    
    class func isSimulator() -> Bool {
        return Platform.isSimulator
    }
    
    class func setBottomBorderForTextField(txtField: UITextField) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: txtField.frame.size.height - width, width:  txtField.frame.size.width, height: txtField.frame.size.height)
        border.borderWidth = width
        txtField.layer.addSublayer(border)
        txtField.layer.masksToBounds = true
    }
    
    class func setShadowForTextField(textField: UITextField) {
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = textField.bounds
        shadowLayer.shadowColor = UIColor(white: 0, alpha: 1).cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = 4
        shadowLayer.fillRule = kCAFillRuleEvenOdd
        let path: CGMutablePath = CGMutablePath()
        path.addRect(textField.bounds.insetBy(dx: -42, dy: -42), transform: .identity)
        let someInnerPath = (UIBezierPath(roundedRect: textField.bounds, cornerRadius: textField.layer.cornerRadius).cgPath)
        path.addPath(someInnerPath, transform: .identity)
        path.closeSubpath()
        shadowLayer.path = path
        textField.layer.addSublayer(shadowLayer)
        let maskLayer = CAShapeLayer()
        maskLayer.path = someInnerPath
        shadowLayer.mask = maskLayer
    }
    
    class func setShadowForTextView(textView: UITextView) {
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = textView.bounds
        shadowLayer.shadowColor = UIColor(white: 0, alpha: 1).cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowRadius = 4
        shadowLayer.fillRule = kCAFillRuleEvenOdd
        let path: CGMutablePath = CGMutablePath()
        path.addRect(textView.bounds.insetBy(dx: -15, dy: -15), transform: .identity)
        let someInnerPath = (UIBezierPath(roundedRect: textView.bounds, cornerRadius: textView.layer.cornerRadius).cgPath)
        path.addPath(someInnerPath, transform: .identity)
        path.closeSubpath()
        shadowLayer.path = path
        textView.layer.addSublayer(shadowLayer)
    }
    
    class func setShadowForView(inView: UIView) {
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = inView.bounds
        shadowLayer.shadowColor = UIColor(white: 0, alpha: 1).cgColor
        shadowLayer.shadowOffset = CGSize(width: 1, height:1)
        shadowLayer.shadowOpacity = 0.7
        shadowLayer.shadowRadius = 4
        shadowLayer.fillRule = kCAFillRuleEvenOdd
        let path: CGMutablePath = CGMutablePath()
        path.addRect(inView.bounds.insetBy(dx: -42, dy: -42), transform: .identity)
        let someInnerPath = (UIBezierPath(roundedRect: inView.bounds, cornerRadius: inView.layer.cornerRadius).cgPath)
        path.addPath(someInnerPath, transform: .identity)
        path.closeSubpath()
        shadowLayer.path = path
        inView.layer.addSublayer(shadowLayer)
        let maskLayer = CAShapeLayer()
        maskLayer.path = someInnerPath
        shadowLayer.mask = maskLayer
    }
    
    class func bottomInnerShadow(imageViewShadow: UIImageView) {
        let gradient = CAGradientLayer()
        gradient.frame = imageViewShadow.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint.init(x: 1, y: 1)
        gradient.endPoint = CGPoint.init(x: 1, y: 0.7)
        if gradient.superlayer == nil {
            imageViewShadow.layer.insertSublayer(gradient, at: 0)
        }
    }
    
    class func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newWidth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    class func load_image(image_url_string:String, view:UIImageView) {
        let URL_IMAGE = URL(string: image_url_string )//"http://www.simplifiedtechy.net/wp-content/uploads/2017/07/simplified-techy-default.png"
        let session = URLSession(configuration: .default)
        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
            if let e = error {                
                print("Error Occurred: \(e)")
            } else {
                if (response as? HTTPURLResponse) != nil {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        view.image = image
                    } else {
                        print("Image file is currupted")
                    }
                } else {
                    print("No response from server")
                }
            }
        }
        getImageFromUrl.resume()
    }
    
    class func setBottomBorderForView(inView: UIView) {
        inView.layer.borderColor = UIColor.black.cgColor
        inView.layer.borderWidth = 1.0;
    }
    
    class func setBoolForKey(_ value: Bool, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func fetchBool(forKey key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    class func setStringForKey(_ value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func fetchString(forKey key: String) -> String {
        if UserDefaults.standard.string(forKey: key) != nil{
            return UserDefaults.standard.string(forKey: key)!
        }
        return "0"
    }
    
    class func applyGradientForUIView(inView:UIView) {
        let layer = UIView(frame: CGRect(x: 0, y: 0, width: 376, height: 618))
        layer.alpha = 0.7
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: inView.frame.width, height: inView.frame.height)
        gradient.colors = [ UIColor(red:65/255, green:67/255, blue:63/255, alpha:1).cgColor, UIColor(red:126/255, green:134/255, blue:100/255, alpha:0.65).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        layer.layer.addSublayer(gradient)
        inView.layer.addSublayer(gradient)
    }
    
    //Price Format
    class func getModifyCurrencyStyle(_ amount: String?, font: UIFont?) -> NSMutableAttributedString? {
        return Utils.getAttrbutedCurrencyString(-2, andFontSize: font, andAmount: amount)
    }
    
    class func getAttrbutedCurrencyString(_ offset: NSNumber?, andFontSize font: UIFont?, andAmount str: String?) -> NSMutableAttributedString? {
        
        let sssstr = str
        var amount_str : String  = String(sssstr?.dropFirst() ?? "0.00")
        let float : Float  = Float(amount_str) ?? 0.00
        amount_str  = String(format: "%.2f", float)
        
        amount_str = Utils.getFractionPart(amount: amount_str)
        
        amount_str = "₪\(String(describing: amount_str))"
        
        let buyString = NSMutableAttributedString(string: amount_str )
        let customFont = UIFont(name: font?.fontName ?? "", size: (font?.pointSize ?? 0.0) + 20)
        
        if let aFont = customFont, let anOffset = offset {
            buyString.setAttributes([NSAttributedStringKey.font: aFont, NSAttributedStringKey.baselineOffset: anOffset], range: NSRange(location: 0, length: 1))//str?.count ?? 0
        }
        
        return buyString
    }
    
    // Freephone Success
    //Price Format
    class func getModifyCurrencyStylefreephone(_ amount: String?, font: UIFont?) -> NSMutableAttributedString? {
        return Utils.getAttrbutedCurrencyStringfreephone(-2, andFontSize: font, andAmount: amount)
    }
    
    class func getAttrbutedCurrencyStringfreephone(_ offset: NSNumber?, andFontSize font: UIFont?, andAmount str: String?) -> NSMutableAttributedString? {
        
        let sssstr = str
        var amount_str : String  = String(sssstr?.dropFirst() ?? "0.00")
        let float : Float  = Float(amount_str) ?? 0.00
        amount_str  = String(format: "%.2f", float)
        amount_str = "₪\(String(describing: amount_str))"
        
        let buyString = NSMutableAttributedString(string: amount_str )
        let customFont = UIFont(name: font?.fontName ?? "", size: (font?.pointSize ?? 0.0) + 20)
        
        if let aFont = customFont, let anOffset = offset {
            buyString.setAttributes([NSAttributedStringKey.font: aFont, NSAttributedStringKey.baselineOffset: anOffset], range: NSRange(location: 0, length: 1))//str?.count ?? 0
        }
        
        return buyString
    }
    
}

extension String {
    func contains(_ find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(_ find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

extension UIDevice {
    static var isIphoneX: Bool {
        var modelIdentifier = ""
        if isSimulator {
            modelIdentifier = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? ""
        } else {
            var size = 0
            sysctlbyname("hw.machine", nil, &size, nil, 0)
            var machine = [CChar](repeating: 0, count: size)
            sysctlbyname("hw.machine", &machine, &size, nil, 0)
            modelIdentifier = String(cString: machine)
        }
        return modelIdentifier == "iPhone10,3" || modelIdentifier == "iPhone10,6"
    }
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    static var isIpadDevice : Bool {
        let model = UIDevice.current.model
        if (model == "iPad")
        {
            // Ipad
            return true
        }
        else
        {
             return false
            // Iphone
        }
    }
    
}

extension UIView {
    func addTopBorder(_ color: UIColor, height: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutAttribute.height,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutAttribute.height,
                                                multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.top,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.top,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.leading,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.leading,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.trailing,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.trailing,
                                              multiplier: 1, constant: 0))
    }
    
    func addBottomBorder(_ color: UIColor, height: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutAttribute.height,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutAttribute.height,
                                                multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.bottom,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.bottom,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.leading,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.leading,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.trailing,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.trailing,
                                              multiplier: 1, constant: 0))
    }
    
    func addLeftBorder(_ color: UIColor, width: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutAttribute.width,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutAttribute.width,
                                                multiplier: 1, constant: width))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.leading,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.leading,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.bottom,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.bottom,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.top,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.top,
                                              multiplier: 1, constant: 0))
    }
    
    func addRightBorder(_ color: UIColor, width: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutAttribute.width,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutAttribute.width,
                                                multiplier: 1, constant: width))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.trailing,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.trailing,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.bottom,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.bottom,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.top,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.top,
                                              multiplier: 1, constant: 0))
    }
    
    
    
    
}
