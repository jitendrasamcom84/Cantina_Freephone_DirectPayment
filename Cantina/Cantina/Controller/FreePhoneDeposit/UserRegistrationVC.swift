//
//  UserRegistrationVC.swift
//  Cantina
//
//  Created by samcom on 18/09/18.
//  Copyright © 2018 AppToDate. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class UserRegistrationVC: BaseViewController, NVActivityIndicatorViewable, UITextFieldDelegate {

    @IBOutlet var txtFirstName: customTextField!
    @IBOutlet var txtLastName: customTextField!
    @IBOutlet var txtCantinaAccountNumber: customTextField!
    @IBOutlet var txtFreePhoneID: customTextField!
    
    @IBOutlet var btnSubmit: UIButton!
    var user : FreePhoneUser = FreePhoneUser()
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.submitButtonVisibility()
    }
    
    // MARK: IB ACTIONS
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        registrationApi()
    }
    
    //MARK: User Registration Api Call
    func registrationApi() {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        
//        let contact: Receiver = Receiver.createEntity()
//        contact.receiver_name = txtFirstName.text! + " " + txtLastName.text!
//        contact.receiver_id = txtCantinaAccountNumber.text!
//        contact.free_user_id = txtFreePhoneID.text!
//        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
//        contact.addContacts { (result, errorMessage) -> (Void) in
//            self.stopAnimating()
//            contact.mr_deleteEntity()
//            contact.saveEntity()
//            if(errorMessage.count > 0){
//                Utils.showAlert(withMessage: errorMessage)
//            }else{
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLoadConatcts), object: nil)
//                self.navigationController?.isNavigationBarHidden = true;
////                let id : String = result["id"] as! String
//                let receiver : Receiver = result as! Receiver
//                let id : String = receiver.entity_id!
//                Utils.setBoolForKey(true, key: isFreePhoneNewUser)
//                let vc = FreePhoneEnteringAmountVC.initViewController(user: id)
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
        
        
        Manager.sharedManager().registerFreePhoneUser(firstName: txtFirstName.text!, lastName: txtLastName.text!) { (response, errorMessage) -> (Void) in
            self.stopAnimating()
            if errorMessage.count > 0 {
                Utils.showAlert(withMessage: errorMessage)
                return
            } else {
                self.navigationController?.isNavigationBarHidden = true;                
                let dataDict : [String:Any] = response as! [String:Any]
                let reciver = Receiver.createEntity()
                reciver.entity_id = dataDict["_id"] as? String
                reciver.main_free_user_id = dataDict["main_free_user_id"] as? String
                reciver.receiver_name = dataDict["receiver_name"] as? String
                reciver.saveEntity()
                Utils.setBoolForKey(true, key: isFreePhoneNewUser)
                let vc = FreePhoneEnteringAmountVC.initViewController(user: reciver.entity_id ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //MARK: Textfield Delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.submitButtonVisibility()
    }
    
    //MARK: Custom Method For Validation
    
    func submitButtonVisibility(){
        let FirstName = txtFirstName.text!.trimmingCharacters(in: .whitespaces)
        let LastName = txtLastName.text!.trimmingCharacters(in: .whitespaces)
        
        btnSubmit.alpha = 0.3;
        btnSubmit.isUserInteractionEnabled = false
        if FirstName.count > 0 && LastName.count > 0 {
            btnSubmit.alpha = 1;
            btnSubmit.isUserInteractionEnabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
