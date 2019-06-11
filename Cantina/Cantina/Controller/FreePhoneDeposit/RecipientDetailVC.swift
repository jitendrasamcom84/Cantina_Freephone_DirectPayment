//
//  RecipientDetailVC.swift
//  Cantina
//
//  Created by samcom on 18/09/18.
//  Copyright © 2018 AppToDate. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RecipientDetailVC: BaseViewController, UITextFieldDelegate, NVActivityIndicatorViewable, UserListDelegate {

    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    @IBOutlet var txtFullName: customTextField!
    @IBOutlet var txtUserId: customTextField!
    
    @IBOutlet weak var btnChooseRecipient: UIButton!
    
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet weak var btnRegisterNewUser: UIButton!
    var userList : FreePhoneUser = FreePhoneUser()
    var receiver : Receiver?
    
    var strFirstName : String = ""
    var strUsrId : String = ""
    
    //MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if strFirstName != "" || strUsrId != "" {
            txtFullName.text = strFirstName
            txtUserId.text = strUsrId
        }
        
        self.submitButtonVisibility()
        NotificationCenter.default.addObserver(self, selector: #selector(checkUserExistApiCallFromNotification), name: NSNotification.Name(rawValue: kCheckUserExists), object: nil)
    }
    
    @objc func checkUserExistApiCallFromNotification() {
        checkUserExistsApi(isNotifcation: true)
    }
    
    //MARK: IB's ACTION
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseReceipientClicked(_ sender: Any) {
        let vc = FreePhoneUserReceiverListVC.initViewController()
        Utils.setBoolForKey(false, key: isFreePhoneNewUser)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func newUserRegistrationClicked(_ sender: Any) {
       // UserDefaults.standard.set(true, forKey: isFreePhoneNewUser)
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserRegistrationVC") as! UserRegistrationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        if let rec = receiver {
            // Already there
            receiver = rec
        }else{
            receiver = Receiver.createEntity()
        }
        let name_arr = txtFullName.text!.split(separator: " ")
        
        if name_arr.count == 1 {
            receiver?.receiver_fname = String(name_arr[0])
            receiver?.receiver_lname = ""
        }
        if name_arr.count == 2 {
            receiver?.receiver_fname = String(name_arr[0])
            receiver?.receiver_lname = String(name_arr[1])
        }
        
        let name = (receiver?.receiver_fname)! + " " + (receiver?.receiver_lname)!
        receiver?.receiver_name = name
        receiver?.free_user_id = txtUserId.text!
        checkUserExistsApi(isNotifcation: false)
    }
    
    //MARK: Check User API Call
    
    @objc func checkUserExistsApi(isNotifcation:Bool) {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        Manager.sharedManager().checkUserExists(userList: receiver!) { (result, errorMessage) -> (Void) in
            self.stopAnimating()
            if(errorMessage.count > 0){
                Utils.showAlert(withMessage: errorMessage)
            }else{
                let id : String = result as! String
                
                let user : Receiver = Receiver.getbyId(userId: id)
                
                self.receiver?.balance = user.balance
                self.receiver?.dateAdded = user.dateAdded
                self.receiver?.entity_id = user.entity_id
                self.receiver?.receiver_fname = user.receiver_fname
                self.receiver?.receiver_lname = user.receiver_lname
                self.receiver?.receiver_name = user.receiver_name
                self.receiver?.is_deleted = user.is_deleted
                self.receiver?.user_id = user.user_id
                self.receiver?.main_free_user_id = user.main_free_user_id
                self.receiver?.free_user_id = user.free_user_id
                self.receiver?.free_user_pass = user.free_user_pass
                
                if isNotifcation == true {
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true);
                }
                else{
                    let vc = DepositMoneyVC.initViewController(user: self.receiver!, isFromNotification: false)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    //MARK: Textfield Delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.submitButtonVisibility();
        
    }
    
    func submitButtonVisibility(){
        let FirstName = txtFullName.text!.trimmingCharacters(in: .whitespaces)
        let UserId = txtUserId.text!.trimmingCharacters(in: .whitespaces)
        lblHeaderTitle.text = "כניסה לפריפון"
//        btnChooseRecipient.titleLabel?.text = "בחר מרשימת הנמענים"
//        btnRegisterNewUser.titleLabel?.text = "רישום נמען חדש"
        btnSubmit.alpha = 0.3;
        btnSubmit.isUserInteractionEnabled = false
        if FirstName.count > 0 && UserId.count > 0 {
            btnSubmit.alpha = 1;
            btnSubmit.isUserInteractionEnabled = true
            lblHeaderTitle.text = "פרטי הנמען"
        }
    }
    
    //MARK: User Selected Delegate Method
    
    func selectedUser(user: Receiver) {
        receiver = user
        
        receiver?.balance = (user.balance?.floatValue)! as NSNumber
        receiver?.dateAdded = user.dateAdded ?? Date()
        receiver?.entity_id = user.entity_id ?? ""
        receiver?.receiver_fname = user.receiver_fname ?? ""
        receiver?.is_deleted = (user.is_deleted != nil) as NSNumber
        receiver?.receiver_lname = user.receiver_lname ?? ""
        receiver?.free_user_id = user.free_user_id ?? ""
        receiver?.main_free_user_id = user.main_free_user_id ?? ""
        receiver?.receiver_name = user.receiver_name ?? ""
        txtFullName?.text = receiver?.receiver_name
        txtUserId.text  = receiver?.free_user_id
        
        receiver?.saveEntity()
        
//        userList.balance = (user.balance?.floatValue)!
//        userList.dateAdded = user.dateAdded ?? Date()
//        userList.entity_id = user.entity_id ?? ""
//        userList.free_receiver_fname = user.receiver_fname ?? ""
//        userList.is_deleted = (user.is_deleted != nil)
//        userList.free_receiver_lname = user.receiver_lname ?? ""
//        userList.free_user_id = user.free_user_id ?? ""
//        userList.main_free_user_id = user.main_free_user_id ?? ""
//        txtFullName.text = user.receiver_name
//        txtUserId.text  = user.free_user_id
        
        self.submitButtonVisibility();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

