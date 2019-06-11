
//
//  DepositMoneyVC.swift
//  Cantina
//
//  Created by samcom on 18/09/18.
//  Copyright © 2018 AppToDate. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DepositMoneyVC: BaseViewController, NVActivityIndicatorViewable{

    @IBOutlet var lblDespositAmount: UILabel!
    @IBOutlet var circleView: UIView!
    @IBOutlet var innerView: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet var vwCircle: UIView!

    var user = FreePhoneUser()
    var receiver = Receiver()
    
    var isFromNotification = Bool()
    
    //MARK: Initializer
    
    class func initViewController(user: Receiver,isFromNotification:Bool) -> DepositMoneyVC {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DepositMoneyVC") as! DepositMoneyVC
        controller.receiver = user
        controller.isFromNotification = isFromNotification
        return controller
    }
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createLayout()
    }
    
    //MARK: Custom Method
    
    func createLayout()  {
        let str1 = "₪\(Utils.getFractionPart(amount: receiver.balance?.stringValue ?? ""))"
        lblDespositAmount.attributedText =  Utils.getModifyCurrencyStyle(str1, font:UIFont(name: "Rubik-Medium", size: 8))
        
        //Set name
        lblName.text = receiver.receiver_name
        
        vwCircle.layer.masksToBounds = true
        vwCircle.layer.borderWidth = 3
        vwCircle.layer.cornerRadius = 110
        vwCircle.layer.borderColor = UIColor.white.cgColor
        
        innerView.layer.masksToBounds = true
        innerView.layer.cornerRadius = 105
        innerView.backgroundColor = UIColor.white
    }
    
    //MARK: - IB's ACTION
    
    @IBAction func backClicked(_ sender: Any) {
        if isFromNotification == true {
            self.navigationController?.popToRootViewController(animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func voiceMessageClicked(_ sender: Any) {
        let vc = ComingSoonVC.initViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func depositClicked(_ sender: Any) {
        let vc = FreePhoneEnteringAmountVC.initViewController(user: receiver)
        vc.id = receiver.entity_id!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
